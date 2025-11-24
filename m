Return-Path: <live-patching+bounces-1877-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6AB96C82574
	for <lists+live-patching@lfdr.de>; Mon, 24 Nov 2025 20:51:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2AC6B3AE00C
	for <lists+live-patching@lfdr.de>; Mon, 24 Nov 2025 19:51:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 780B431A06C;
	Mon, 24 Nov 2025 19:51:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="awhKsmSn"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48A4B17C21B;
	Mon, 24 Nov 2025 19:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764013872; cv=none; b=UDw7m65ncVyT1m2tvxCbtHSJS56SN0M2A3lHXlmPzIOGBe15eFtCuOeBmL3YDYyttBNG2utkWulNCT8MYYxce8Z/EFyKdtsZC1/SHKjL7xVB1jXFwRwBEI/C7BnsCZ/RD7sOlC/zrN4xdYmHEKXhCDN7NFT/wQgeJdE7UhXA9ss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764013872; c=relaxed/simple;
	bh=xdlf16msq3x8vp5vcDDFqHrHX1fBq4dtska1TgUXu4Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U/9kk7D0MXMGyNeCBjDkHaZ4BKpZVSqzHyUJGF2D8AElsZtQcYZsq1sDGO3PvVMGLfCDLoo5DDdGs3B6YXix6LhWqhySs+JpU6wIhXBe6uIouZC0POjj/jDRFwhYphzS91hHROD1lWISJm7dZXlk+uGH4QQQGAmObwVlQ39zwwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=awhKsmSn; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C09DAC4CEF1;
	Mon, 24 Nov 2025 19:51:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764013868;
	bh=xdlf16msq3x8vp5vcDDFqHrHX1fBq4dtska1TgUXu4Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=awhKsmSncRgUycaIImTcG2AmQbrSdfTQVFNc9emJ05C7VBZvK6318+qIdDGNj+Se1
	 r7PinhASUJ9S8sIc9pWYmbCwNByyZaMWKNYQ55I5jAqNcibn5IbduZlKZIUP5A29IM
	 KFiw7pXK9f89jC6F9Bc1mP31TslVjmXCPjnthlHNxneUL42RYDQegt3OnhOz/JdGnz
	 fvj5jKQM8VqbqnaeHvlGQZMnpWcHkV9yKLcZ3TAXfI/1P3H4mH7tvnRDtpAqpiG0Nb
	 ahaAMtE6ZhTesPXFxX5ni0rF6m06n4+PtBoymKZVffVsGdug42mx69LXTdvW3M4LJo
	 nl43Js3l2os8g==
Date: Mon, 24 Nov 2025 11:51:06 -0800
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Miroslav Benes <mbenes@suse.cz>, 
	Andrey Grodzovsky <andrey.grodzovsky@crowdstrike.com>, bpf <bpf@vger.kernel.org>, live-patching@vger.kernel.org, 
	DL Linux Open Source Team <linux-open-source@crowdstrike.com>, Petr Mladek <pmladek@suse.com>, Song Liu <song@kernel.org>, 
	Andrii Nakryiko <andrii@kernel.org>, Raja Khan <raja.khan@crowdstrike.com>
Subject: Re: BPF fentry/fexit trampolines stall livepatch stalls transition
 due to missing ORC unwind metadata
Message-ID: <yarich5x6bdyhkpo526rnbzbo45uizt7lod5d6soyvvt4hsiim@g3btfaqwsw3v>
References: <0e555733-c670-4e84-b2e6-abb8b84ade38@crowdstrike.com>
 <alpine.LSU.2.21.2511201311570.16226@pobox.suse.cz>
 <h4e7ar2fckfs6y2c2tm4lq4r54edzvqdq6cy5qctb7v3bi5s2u@q4hfzrlembrn>
 <CAADnVQLWD5-z6uajf=WzKj1J2V6+fc1wNBTzBJj3ufbskMEoPA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAADnVQLWD5-z6uajf=WzKj1J2V6+fc1wNBTzBJj3ufbskMEoPA@mail.gmail.com>

On Mon, Nov 24, 2025 at 09:14:59AM -0800, Alexei Starovoitov wrote:
> On Fri, Nov 21, 2025 at 4:56 PM Josh Poimboeuf <jpoimboe@kernel.org> wrote:
> >
> >
> > Maybe we can take advantage of the fact that BPF uses frame pointers
> > unconditionally, and avoid the complexity of "dynamic ORC" for now, by
> > just having BPF keep track of where the frame pointer is valid (after
> > the prologue, before the epilogue).
> 
> ...
> >                         EMIT1(0xC9);         /* leave */
> > +                       bpf_prog->aux->ksym.fp_end = prog - temp;
> > +
> >                         emit_return(&prog, image + addrs[i - 1] + (prog - temp));
> >                         break;
> >
> > @@ -3299,6 +3304,8 @@ static int __arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *rw_im
> >         }
> >         EMIT1(0x55);             /* push rbp */
> >         EMIT3(0x48, 0x89, 0xE5); /* mov rbp, rsp */
> > +       im->ksym.fp_start = prog - (u8 *)rw_image;
> > +
> 
> Overall makes sense to me, but do you have to skip the prologue/epilogue ?
> What happens if it's just bpf_ksym_find() ?
> Only irq can interrupt this push/mov sequence and it uses a different irq stack.

On x86-64, IRQs actually just use the task stack, but that doesn't
really matter: either way ORC needs to unwind through it and it needs to
know whether the unwind info is reliable.

If BPF gets preempted in the prologue, and ORC just does bpf_ksym_find()
and assumes frame pointer, the unwind will either fail outright or skip
stack frames.

Particularly for the latter case that would break live patching.

Today it already tries to fall back to frame pointers for BPF, and that
usually works.  But it marks the unwind as "unreliable" because it's
just a guess.

This patch would help mark the typical non-preempted BPF case as
"reliable" so it would work with live patching.

-- 
Josh

