Return-Path: <live-patching+bounces-1159-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 721F8A333A7
	for <lists+live-patching@lfdr.de>; Thu, 13 Feb 2025 00:50:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 043E73A8872
	for <lists+live-patching@lfdr.de>; Wed, 12 Feb 2025 23:49:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 368E420967E;
	Wed, 12 Feb 2025 23:49:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ceKxZu1j"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0476F126C05;
	Wed, 12 Feb 2025 23:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739404189; cv=none; b=ri+PFJkclg9dHc/vG/3pMAwMJLk3gCf8yR1hL8TC37OqRstEyM7ubNuaVt0Bgkh/E/GtuRO5K+B9K3jKZqgT0deZ/LGjCXq1FeAhanOtsggu8VYu8lix0xuhyQ3bpaq5UuBUwTyrhgysnRNR+Owi+6YrxR27vQN1ofmPPfbGPHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739404189; c=relaxed/simple;
	bh=FGFJHoLpbX4ySRnxs3bfJkdLdlmxhJIsYSNovBRH/qY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=m7dCxR6TNz+qy2OQFJUsURByPqbzDiifsCbSluH1ru8VyQKePMIHsjmyI1uwJLN40GdsMgB0014hjUYTOdSaWEPqva7PVuhFPRSKdITzKzsRfXgrDTxTleSYeC+ETcuMfq+Hp3FnlRAfPpPbNuMqwRQc4ULCrjUYM0nKmR8W/78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ceKxZu1j; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8B14C4CEDF;
	Wed, 12 Feb 2025 23:49:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739404188;
	bh=FGFJHoLpbX4ySRnxs3bfJkdLdlmxhJIsYSNovBRH/qY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ceKxZu1jn6eoyI8R1Jdqmo8izXjI15NYJ+bvYiFJPlkFiSauSqexaCKdbElLr1uCc
	 mFC8xlRJcLyxMVQJCyStPbdTNUcfCkNXTyJlO/eoBDE83k/RaH6NkHFNchBKz5Ito4
	 rbON7EKyXBSVM0dUu2DU1XLFmahq0dEaYXeEXAnBkjk8EVHGvAp1GNHpIxfVyS0djJ
	 dJlHjz/RLz1mrEs8GYYOUBAuGn2ETTc/A9C9uQwAgBUjs0j+7ov1e7yMq0VIXG/H2t
	 i4JPJAcmRi33/f7Q+i+AVg3hLywiWQE8oNUDd72oeZ9UZL6aijYKIETYbZu8MtjP7w
	 W1NKQCDWPA6ew==
Date: Wed, 12 Feb 2025 15:49:46 -0800
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Song Liu <song@kernel.org>
Cc: Weinan Liu <wnliu@google.com>, Steven Rostedt <rostedt@goodmis.org>,
	Indu Bhagat <indu.bhagat@oracle.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Mark Rutland <mark.rutland@arm.com>, roman.gushchin@linux.dev,
	Will Deacon <will@kernel.org>, Ian Rogers <irogers@google.com>,
	linux-toolchains@vger.kernel.org, linux-kernel@vger.kernel.org,
	live-patching@vger.kernel.org, joe.lawrence@redhat.com,
	linux-arm-kernel@lists.infradead.org,
	Puranjay Mohan <puranjay@kernel.org>
Subject: Re: [PATCH 0/8] unwind, arm64: add sframe unwinder for kernel
Message-ID: <20250212234946.yuskayyu4gx3ul7m@jpoimboe>
References: <20250127213310.2496133-1-wnliu@google.com>
 <CAPhsuW6S1JPn0Dp+bhJiSVs9iUv7v7HThBSE85iaDAvw=_2TUw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAPhsuW6S1JPn0Dp+bhJiSVs9iUv7v7HThBSE85iaDAvw=_2TUw@mail.gmail.com>

On Wed, Feb 12, 2025 at 03:32:40PM -0800, Song Liu wrote:
> [   81.250437] ------------[ cut here ]------------
> [   81.250818] refcount_t: saturated; leaking memory.
> [   81.251201] WARNING: CPU: 0 PID: 95 at lib/refcount.c:22
> refcount_warn_saturate+0x6c/0x140
> [   81.251841] Modules linked in: livepatch_special_static(OEK)
> [   81.252277] CPU: 0 UID: 0 PID: 95 Comm: bash Tainted: G
> OE K    6.13.2-00321-g52d2813b4b07 #49
> [   81.253003] Tainted: [O]=OOT_MODULE, [E]=UNSIGNED_MODULE, [K]=LIVEPATCH
> [   81.253503] Hardware name: linux,dummy-virt (DT)
> [   81.253856] pstate: 634000c5 (nZCv daIF +PAN -UAO +TCO +DIT -SSBS BTYPE=--)
> [   81.254383] pc : refcount_warn_saturate+0x6c/0x140
> [   81.254748] lr : refcount_warn_saturate+0x6c/0x140
> [   81.255114] sp : ffff800085a6fc00
> [   81.255371] x29: ffff800085a6fc00 x28: 0000000001200000 x27: ffff0000c2966180
> [   81.255918] x26: 0000000000000000 x25: ffff8000829c0000 x24: ffff0000c2e9b608
> [   81.256462] x23: ffff800083351000 x22: ffff0000c2e9af80 x21: ffff0000c062e140
> [   81.257006] x20: ffff0000c1c10c00 x19: ffff800085a6fd80 x18: ffffffffffffffff
> [   81.257544] x17: 0000000000000001 x16: ffffffffffffffff x15: 0000000000000006
> [   81.258083] x14: 0000000000000000 x13: 2e79726f6d656d20 x12: 676e696b61656c20
> [   81.258625] x11: ffff8000829f7d70 x10: 0000000000000147 x9 : ffff8000801546b4
> [   81.259165] x8 : 00000000fffeffff x7 : 00000000ffff0000 x6 : ffff800082f77d70
> [   81.259709] x5 : 80000000ffff0000 x4 : 0000000000000000 x3 : 0000000000000001
> [   81.260257] x2 : ffff8000829f7a88 x1 : ffff8000829f7a88 x0 : 0000000000000026
> [   81.260824] Call trace:
> [   81.261015]  refcount_warn_saturate+0x6c/0x140 (P)
> [   81.261387]  __refcount_add.constprop.0+0x60/0x70
> [   81.261748]  copy_process+0xfdc/0xfd58 [livepatch_special_static]

Does that copy_process+0xfdc/0xfd58 resolve to this line in
copy_process()?

			refcount_inc(&current->signal->sigcnt);

Maybe the klp rela reference to 'current' is bogus, or resolving to the
wrong address somehow?

-- 
Josh

