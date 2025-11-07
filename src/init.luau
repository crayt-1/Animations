local Animations = {}
Animations._animators = {}

function Animations.getAnimator(anyAnimatorParent: Instance, animatorName: string?): Animator | never
	if anyAnimatorParent:IsA("Player") then
		if not anyAnimatorParent.Character then
			return nil
		end
		return anyAnimatorParent.Character:WaitForChild("Humanoid", math.huge):WaitForChild("Animator", math.huge)
	end

	for _, descendant in anyAnimatorParent:GetDescendants() do
		if descendant:IsA("Animator") then
			if animatorName and descendant.Name ~= animatorName then
				continue
			end
			return descendant
		end
	end

	return nil
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
