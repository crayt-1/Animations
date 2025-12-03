local Animations = {}
Animations._animators = {}

function Animations.getAnimator(ancestor: Instance): Animator?
	return ancestor:FindFirstChildWhichIsA("Animator", true)
end

function Animations.get(self: Animations, animator: Animator, animation: Animation | number | string)
	local animations = self._animators[animator]
	if not Animations then
		return nil
	end

	for _animation, animationTrack in animations do
		if typeof(animation) == "number" then
			if _animation.AnimationId:match(animation) then
				return animationTrack
			end
		elseif typeof(animation) == "string" then
			if _animation.AnimationId == animation then
				return animationTrack
			end
		elseif typeof(animation) == "Instance" then
			if _animation == animation then
				return animationTrack
			end
		end
	end
end

function Animations.load(self: Animations, animator: Animator, animation: Animation | number | string)
	if typeof(animation) == "number" then
		local animationId = animation
		animation = Instance.new("Animation")
		animation.AnimationId = "rbxassetid://" .. animationId
	elseif typeof(animation) == "string" then
		local animationId = animation
		animation = Instance.new("Animation")
		animation.AnimationId = animationId
	end

	if not self._animators[animator] then
		self._animators[animator] = {}
	end

	local animationTrack = animator:LoadAnimation(animation)

	self._animators[animator][animation] = animationTrack

	return animationTrack
end

export type Animations = typeof(Animations)

return Animations :: Animations
