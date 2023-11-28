import { BaseAuthEvent } from './base_auth_event'
import { EventDocument, ProductDocument, UserChatRoomDocument, UserDocument } from '../models'

export type UserSignedUpRestPayload = {
	id: string
	name: string
	email: string
	profileImage: string
	school: string
	verified: boolean
	myEvent: EventDocument[]
	recentSearchHistory: string[]
	recentViewHistory: ProductDocument[]
	like: ProductDocument[]
	selling: ProductDocument[]
	bought: ProductDocument[]
	sold: ProductDocument[]
	myChatRoom: UserChatRoomDocument[]
	type: string
}

export default class UserSignedUp extends BaseAuthEvent<UserSignedUpRestPayload> {
	private user: UserDocument

	private statusCode = 201

	constructor(user: UserDocument) {
		super()
		this.user = user
	}

	getStatusCode(): number {
		return this.statusCode
	}

	serializeRest(): UserSignedUpRestPayload {
		return {
			id: this.user._id,
			name: this.user.name,
			email: this.user.email,
			profileImage: this.user.profileImage,
			school: this.user.school,
			verified: this.user.verified,
			myEvent: this.user.myEvent,
			recentSearchHistory: this.user.recentSearchHistory,
			recentViewHistory: this.user.recentViewHistory,
			like: this.user.like,
			selling: this.user.selling,
			bought: this.user.bought,
			sold: this.user.sold,
			myChatRoom: this.user.myChatRoom,
			type: this.user.type,
		}
	}
}
