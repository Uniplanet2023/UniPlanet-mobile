import { FieldValidationError } from 'express-validator'
import { BaseCustomError } from './index'
import { SerializedErrorField, SerializedErrorOutput } from './type/serialized_error_output'

export type InvalidInputConstructorErrorsParam = FieldValidationError[]

export default class InvalidInput extends BaseCustomError {
	private readonly errors: FieldValidationError[] | undefined

	private statusCode = 422

	private defaultErrorMessage = 'The input provided is invalid.'

	constructor(errors?: InvalidInputConstructorErrorsParam) {
		super('The input provided is invalid.')
		this.errors = errors
		Object.setPrototypeOf(this, InvalidInput.prototype)
	}

	getStatusCode(): number {
		return this.statusCode
	}

	serializeErrorOutput(): SerializedErrorOutput {
		return this.parseValidationErrors()
	}

	private parseValidationErrors(): SerializedErrorOutput {
		const parsedErrors: SerializedErrorField = {}

		if (this.errors && this.errors.length > 0) {
			this.errors.forEach(error => {
				if (parsedErrors[error.path]) {
					parsedErrors[error.path].push(error.msg)
				} else {
					parsedErrors[error.path] = [error.msg]
				}
			})
		}

		return {
			errors: [
				{
					message: this.defaultErrorMessage,
					fields: parsedErrors,
				},
			],
		}
	}
}
