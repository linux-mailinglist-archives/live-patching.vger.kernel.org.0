Return-Path: <live-patching+bounces-1518-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F8E5AD63C0
	for <lists+live-patching@lfdr.de>; Thu, 12 Jun 2025 01:13:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BD84C3A1ED9
	for <lists+live-patching@lfdr.de>; Wed, 11 Jun 2025 23:12:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A529F27054A;
	Wed, 11 Jun 2025 23:12:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cCJvU3A6"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C9072701B3;
	Wed, 11 Jun 2025 23:12:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749683540; cv=none; b=Ms65gra6RzHtyZSavqwtAOKtAwSJfcG/QJtj5FdcFUcFLtyM+vJjNSUhZ753xLGXOW8h2/uYHSVcwBGyqBRqr6o7RedYBszzSfTXhegNkKh5QHG1fu0TKbTxH87px3+Q77Dheo4JOUuwqUUsrvbfyLoClbsK1Pq0648i+BgR3IM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749683540; c=relaxed/simple;
	bh=YlVscud+DHYOdj0woFplsZHA3xfxQyKot3ngoy1iubc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=atqBxWJgb74r7IJq+wedS2gIF3LT9uAVyOhI6F1oi059QdJIDyaNrowVlKgtWKJhgdIn3W/0JQ2kWaEUBSIOdyV8H82IXwONTwZvcdwYg3jiRGE+jkobZww9QwTgNPRL4EFb89G0o/4L+CuhJBgORIGkIV14N1UAfzfaV5uWvQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cCJvU3A6; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A939C4CEE3;
	Wed, 11 Jun 2025 23:12:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749683538;
	bh=YlVscud+DHYOdj0woFplsZHA3xfxQyKot3ngoy1iubc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cCJvU3A6AsToKfF27xCXKe2jokg95/pMewWR0XRblt9Ws+uBLaDvsh+Q0LR2LBg/L
	 f7cMw4Oi38juqhGo1qzQwmve41gLiyYa0F90ebSLNghrHCaIck3c2hrOIq/FSYzrNf
	 vvRCEGZLWKdQf4SqFiF3zrtEGT9K9CuWVM3s7vBkkUE0WDiNLdx6bDmZG7d/6g4xvP
	 qbMVS73KZqH60cDBZ0mPag5USeAGWvPJH+s9SQlB1KtZ2V6KOVbNbzFx4dPjdix+Me
	 jC7JX/G3+Qd85wIul95VUp9jc8tAtL2yUNb5OwAFUlh4jSismePi7cxTE9Vdy2qYda
	 3gI77Bjz9NWMQ==
Date: Wed, 11 Jun 2025 16:12:14 -0700
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Joe Lawrence <joe.lawrence@redhat.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
	Petr Mladek <pmladek@suse.com>, Miroslav Benes <mbenes@suse.cz>, live-patching@vger.kernel.org, 
	Song Liu <song@kernel.org>, laokz <laokz@foxmail.com>, Jiri Kosina <jikos@kernel.org>, 
	Marcos Paulo de Souza <mpdesouza@suse.com>, Weinan Liu <wnliu@google.com>, 
	Fazla Mehrab <a.mehrab@bytedance.com>, Chen Zhongjin <chenzhongjin@huawei.com>, 
	Puranjay Mohan <puranjay@kernel.org>
Subject: Re: [PATCH v2 59/62] livepatch/klp-build: Introduce klp-build script
 for generating livepatch modules
Message-ID: <3nloqn2gjfn7rkaqsebb5wp4zikgwa7tfslvmv53bt4unuvu7d@p3q6qfskvhmo>
References: <cover.1746821544.git.jpoimboe@kernel.org>
 <10ccbeb0f4bcd7d0a10cc9b9bd12fdc4894f83ee.1746821544.git.jpoimboe@kernel.org>
 <305c6d06-ae85-4595-ba05-9aa7b93739bd@redhat.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <305c6d06-ae85-4595-ba05-9aa7b93739bd@redhat.com>

On Wed, Jun 11, 2025 at 05:44:23PM -0400, Joe Lawrence wrote:
> On 5/9/25 4:17 PM, Josh Poimboeuf wrote:
> > +revert_patches() {
> > +	local extra_args=("$@")
> > +	local patches=("${APPLIED_PATCHES[@]}")
> > +
> > +	for (( i=${#patches[@]}-1 ; i>=0 ; i-- )) ; do
> > +		revert_patch "${patches[$i]}" "${extra_args[@]}"
> > +	done
> > +
> > +	APPLIED_PATCHES=()
> > +
> > +	# Make sure git actually sees the patches have been reverted.
> > +	[[ -d "$SRC/.git" ]] && (cd "$SRC" && git update-index -q --refresh)
> > +}
> 
> < warning: testing entropy field fully engaged :D >
> 
> Minor usability nit: I had run `klp-build --help` while inside a VM that
> didn't seem to have r/w access to .git/.  Since the cleanup code is
> called unconditionally, it gave me a strange error when running this
> `git update-index` when I never supplied any patches to operate on. I
> just wanted to see the usage.
> 
> Could this git update-index be made conditional?
> 
>   if (( ${#APPLIED_PATCHES[@]} > 0 )); then
>       ([[ -d "$SRC/.git" ]] && cd "$SRC" && git update-index -q --refresh)
>       APPLIED_PATCHES=()
>   fi
> 
> Another way to find yourself in this function is to move .git/ out of
> the way.  In that case, since it's the last line of revert_patches(), I
> think the failure of [[ -d "$SRC/.git" ]] causes the script to
> immediately exit:
> 
>   - for foo.patch, at the validate_patches() -> revert_patches() call
>   - for --help, at the cleanup() -> revert_patches() call
> 
> So if you don't like the conditional change above, should
> revert_patches() end with `true` to eat the [[ -d "$SRC/.git" ]] status?
>  Or does that interfere with other calls to that function throughout the
> script?
> 
> FWIW, with either adjustment, the script seems happy to operate on a
> plain ol' kernel source tree without git.

Hm, revert_patch() already has a call to git_refresh(), so there doesn't
appear to be any point to that extra refresh in revert_patches().

Does this fix?

diff --git a/scripts/livepatch/klp-build b/scripts/livepatch/klp-build
index 7ec07c4079f7..e6dbac89ab03 100755
--- a/scripts/livepatch/klp-build
+++ b/scripts/livepatch/klp-build
@@ -388,9 +388,6 @@ revert_patches() {
 	done
 
 	APPLIED_PATCHES=()
-
-	# Make sure git actually sees the patches have been reverted.
-	[[ -d "$SRC/.git" ]] && (cd "$SRC" && git update-index -q --refresh)
 }
 
 validate_patches() {

