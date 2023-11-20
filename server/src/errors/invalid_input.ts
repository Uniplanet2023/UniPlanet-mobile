import { FieldValidationError } from 'express-validator';
import { BaseCustomError } from './base_custom_error';
import {
	SerializedErrorField,
	SerializedErrorOutput,
} from './type/serialized_error_output';

export type InvalidInputConstructorErrorsParam = FieldValidationError[];

export default class InvalidInput extends BaseCustomError {
	protected statusCode = 422;

	protected errors: FieldValidationError[] | undefined;

	private errorMessage = 'The input provided is invalid.';

	constructor(errors?: InvalidInputConstructorErrorsParam) {
		super('The input provided is invalid.');
		this.errors = errors;
		Object.setPrototypeOf(this, InvalidInput.prototype);
	}

	getStatusCode(): number {
		return this.statusCode;
	}

	serializeErrorOutput(): SerializedErrorOutput {
		return this.parseValidationErrors();
	}

	private parseValidationErrors(): SerializedErrorOutput {
		const parsedErrors: SerializedErrorField = {};

		if (this.errors && this.errors.length > 0) {
			this.errors.forEach((error) => {
				if (parsedErrors[error.path]) {
					parsedErrors[error.path].push(error.msg);
				} else {
					parsedErrors[error.path] = [error.msg];
				}
			});
		}

		return {
			errors: [
				{
					message: this.errorMessage,
					fields: parsedErrors,
				},
			],
		};
	}
}
