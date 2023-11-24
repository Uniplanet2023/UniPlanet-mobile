import { SerializedErrorOutput } from './type/serialized_error_output';

export default abstract class BaseCustomError extends Error {
	protected abstract statusCode: number;

	protected abstract defaultErrorMessage: string;

	protected constructor(message?: string) {
		super(message);

		Object.setPrototypeOf(this, BaseCustomError.prototype);
	}
	abstract getStatusCode(): number;
	abstract serializeErrorOutput(): SerializedErrorOutput;
}
