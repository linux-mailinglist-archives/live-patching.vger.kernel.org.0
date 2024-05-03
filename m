Return-Path: <live-patching+bounces-231-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C5E138BB568
	for <lists+live-patching@lfdr.de>; Fri,  3 May 2024 23:15:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 037951C20D36
	for <lists+live-patching@lfdr.de>; Fri,  3 May 2024 21:15:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4E7A58ACC;
	Fri,  3 May 2024 21:14:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pMrXfPsp"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79AFC5103D;
	Fri,  3 May 2024 21:14:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714770879; cv=none; b=nFpI5wfk1+aKq/mpo7/rha3TRbJqYyWemNbh8VmZxtoygnRg3Br7abj6r4eimiwQfbpaLcNIP80glD4573r1Hgk04FKD3HDnxRmWc5EFfq1Ag2eBclIpgggR2lFRNbkF/pxr535v+tBh9Bdqd79gYVxESeWW2gx7vAAuSqfmpJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714770879; c=relaxed/simple;
	bh=5neAYOA3EFfcu8SA4sdg9wAwj2fYvkfyICLza5pq0RM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IGBFe3yWMtsEhOYPVcosSQqa8KbhXw9y1iPmF0e/KtS02emxbmbcWSEz0BXApzI7y3uKr45HeKN7WXJofo1jmVwTtZWVu04+GMo1sFNQBkZVrSh5TK3V5dmh5X7+nmqLQDwz9s2DL56FHp5gxxQLuPq7NKrZk1BWs9PnCpbqAQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pMrXfPsp; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9B45C2BBFC;
	Fri,  3 May 2024 21:14:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714770879;
	bh=5neAYOA3EFfcu8SA4sdg9wAwj2fYvkfyICLza5pq0RM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pMrXfPspjJ4CM/8S42UsqEm92E/qvEhkkjCSEwq/8eeeYs45BKH+WYL5/DS8MGeqd
	 OXiZpHciTggx3B890AUdbJFpA/d+TPxDoSc30FMv7Tr5PnlIuwSb2wjnotKodeKGC+
	 23qQ44vb86bvNtpypM4LNOL8UtnHeDJnNpOPKKq8h+fXzP7Qf0+LwXJLMcCm2vC3rY
	 PdQjmn7BByAMoE4wJ7A8Q0lwGYvt65bNqYCnKvHwRvQ+wk3YZUeE9/IEJ0JzEOH/y0
	 p//trq58O3mQvpmxJDaBvOm3SwPG7Hch4pZT1GZKVwlCyY1ytDEkSZKLiwayYzHkgp
	 x4GQQWpxBcUjQ==
Date: Fri, 3 May 2024 14:14:34 -0700
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Yafang Shao <laoar.shao@gmail.com>
Cc: jikos@kernel.org, mbenes@suse.cz, pmladek@suse.com,
	joe.lawrence@redhat.com, mcgrof@kernel.org,
	live-patching@vger.kernel.org, linux-modules@vger.kernel.org
Subject: Re: [PATCH v2 2/2] livepatch: Delete the associated module of
 disabled livepatch
Message-ID: <20240503211434.wce2g4gtpwr73tya@treble>
References: <20240407035730.20282-1-laoar.shao@gmail.com>
 <20240407035730.20282-3-laoar.shao@gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240407035730.20282-3-laoar.shao@gmail.com>

On Sun, Apr 07, 2024 at 11:57:30AM +0800, Yafang Shao wrote:
>   $ ls /sys/kernel/livepatch/
>   livepatch_test_1                  <<<< livepatch_test_0 was replaced
> 
>   $ cat /sys/kernel/livepatch/livepatch_test_1/enabled
>   1
> 
>   $ lsmod  | grep livepatch
>   livepatch_test_1       16384  1
>   livepatch_test_0       16384  0    <<<< leftover
> 
> Detecting which livepatch will be replaced by the new one from userspace is
> not reliable, necessitating the need for the operation to be performed
> within the kernel itself. With this improvement, executing
> `insmod livepatch-test_1.ko` will automatically remove the
> livepatch-test_0.ko module.
> 
> Following this change, the associated kernel module will be removed when
> executing `echo 0 > /sys/kernel/livepatch/${livepath}/enabled`. Therefore,
> adjustments need to be made to the selftests accordingly.

If the problem is that the user can't see which livepatch has been
disabled, we should just fix that problem directly by leaving the
disabled module in /sys/kernel/livepatch with an 'enabled' value of 0.

'enabled' could then be made read-only for replaced files.

That seems less disruptive to the user (and more consistent with the
previous interface), and continues to leave the policy up to the user to
decide if/when they want to remove the module.

It would also allow easily downgrading the replaced module in the future
(once we have proper support for that).

-- 
Josh

