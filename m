Return-Path: <live-patching+bounces-1864-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1FE17C669FF
	for <lists+live-patching@lfdr.de>; Tue, 18 Nov 2025 01:11:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by tor.lore.kernel.org (Postfix) with ESMTPS id 31381293FF
	for <lists+live-patching@lfdr.de>; Tue, 18 Nov 2025 00:11:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CBA715855E;
	Tue, 18 Nov 2025 00:10:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Fl6EvuYn"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 681351494C3;
	Tue, 18 Nov 2025 00:10:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763424651; cv=none; b=WmPKFcb+ILVDUYujhvGkqzwLDi7Bg97yisLAyQZ1EQqHzmZ03wUlHyXXGB2l1NE8FltH+7o6TCSgF1dbr1eSpzvJaZnmXrdYwd4kn+qHrmEWXnOyDDNm2N2R1K//3X6T4qOZnrUeaObZFGbmtK8+C8fDr1CtZJFHF5GJRY0S4l4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763424651; c=relaxed/simple;
	bh=AdmDhGT5GaUYMGxYDS8eezspUbTOzGRVQGgCMIEeZ/U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mTdQQdDJNdQG5qZfGnyqIPDzquOiOOthbnkzrniwYGmp27ZOLF4mepYkh5rCY1Alqvdz55trM5d+NFL99FlMEVa5Ol0rAFNZ3qcbeSwf9VZjsqvWbw2IJg3FxacWJKk63CUPE9tu2bMqbszEfUlehhdfvs/VluESpnc65JeFLlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Fl6EvuYn; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B25BC2BCB0;
	Tue, 18 Nov 2025 00:10:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763424650;
	bh=AdmDhGT5GaUYMGxYDS8eezspUbTOzGRVQGgCMIEeZ/U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Fl6EvuYndwcQgE1d7HrQDcuZCZc5wfspAE7VOXLw3pjN/a1MrN96diYsFM/mjT1Is
	 7GaZRdl/i/lOf8IrdPt9TI95AeEonVy7h+BFt2x3Uf8coToeuzVtojlna3SWi26zUL
	 1diDl9bAJJ9M9neS4x/kYQoeRdoEYhu3Z0OvOX+Z/qQlJPz36qa5BMJqpleQa/JPJj
	 jkiM0iVsuMqrtYlcdwgTFy+fJWfysrn0JL7gOaVrYXWbkKtgdJKKcG1T7a3xlTmmgt
	 7gLfaQPZ8SrhfiiPrkV7/iA2hQH3t1dWdeWgXQhBOAQrSJV3WqDrbeEcOZ4yIpPvDu
	 Xy2ZnpnA7D8GQ==
Date: Mon, 17 Nov 2025 16:10:46 -0800
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Dylan Hatch <dylanbhatch@google.com>, 
	Puranjay Mohan <puranjay12@gmail.com>, Song Liu <song@kernel.org>, Indu Bhagat <indu.bhagat@oracle.com>, 
	Peter Zijlstra <peterz@infradead.org>, Will Deacon <will@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Jiri Kosina <jikos@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Weinan Liu <wnliu@google.com>, 
	Mark Rutland <mark.rutland@arm.com>, Ian Rogers <irogers@google.com>, 
	linux-toolchains@vger.kernel.org, linux-kernel@vger.kernel.org, live-patching@vger.kernel.org, 
	joe.lawrence@redhat.com, Puranjay Mohan <puranjay@kernel.org>
Subject: Re: [PATCH v2 0/6] unwind, arm64: add sframe unwinder for kernel
Message-ID: <cxxj6lzs226ost6js5vslm52bxblknjwd6llmu24h3bk742zjh@7iwwi5bafysq>
References: <20250904223850.884188-1-dylanbhatch@google.com>
 <CAPhsuW5zUEeM3DAw-3OVNS9KmM2vG9B1GaR9KEKS_KFQo-VG9Q@mail.gmail.com>
 <CANk7y0hUKOVXRKoJ5Ufmg-5DGSe2F5nBH+O7tLVvLRs9Oe54uA@mail.gmail.com>
 <CADBMgpwZ32+shSa0SwO8y4G-Zw14ae-FcoWreA_ptMf08Mu9dA@mail.gmail.com>
 <nzmtsafrx5vjitgfpducjaa7kq747a3sler2vvyvfbxecutn3v@7ffl2ycnaoo2>
 <20251117184223.3c03fe92@gandalf.local.home>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20251117184223.3c03fe92@gandalf.local.home>

On Mon, Nov 17, 2025 at 06:42:23PM -0500, Steven Rostedt wrote:
> On Mon, 17 Nov 2025 15:06:32 -0800
> Josh Poimboeuf <jpoimboe@kernel.org> wrote:
> 
> > The ORC unwinder marks the unwind "unreliable" if it has to fall back to
> > frame pointers.
> > 
> > But that's not a problem for livepatch because it only[*] unwinds
> > blocked/sleeping tasks, which shouldn't have BPF on their stack anyway.
> > 
> > [*] with one exception: the task calling into livepatch
> 
> It may be a problem with preempted tasks right? I believe with PREEMPT_LAZY
> (and definitely with PREEMPT_RT) BPF programs can be preempted.

In that case, then yes, that stack would be marked unreliable and
livepatch would have to go try and patch the task later.

If it were an isolated case, that would be fine, but if BPF were
consistently on the same task's stack, it could stall the completion of
the livepatch indefinitely.

I haven't (yet?) heard of BPF-induced livepatch stalls happening in
reality, but maybe it's only a matter of time :-/

To fix that, I suppose we would need some kind of dynamic ORC
registration interface.  Similar to what has been discussed with
sframe+JIT.

If BPF were to always use frame pointers then there would be only a very
limited set of ORC entries (either "frame pointer" or "undefined") for a
given BPF function and it shouldn't be too complicated.

-- 
Josh

