Return-Path: <live-patching+bounces-2847-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YJLjKbyVC2rXJgUAu9opvQ
	(envelope-from <live-patching+bounces-2847-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 19 May 2026 00:42:04 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 512DC574B63
	for <lists+live-patching@lfdr.de>; Tue, 19 May 2026 00:42:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 158E330387AC
	for <lists+live-patching@lfdr.de>; Mon, 18 May 2026 22:42:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C4C33921E4;
	Mon, 18 May 2026 22:42:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="c4h8P07d"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-ua1-f51.google.com (mail-ua1-f51.google.com [209.85.222.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BB4B381B0A
	for <live-patching@vger.kernel.org>; Mon, 18 May 2026 22:41:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779144120; cv=pass; b=k71jI78MxdpsrBpo3mKDuvHWXT30MF63svE2bgbh2Hwg4O4fWjgy9+ytVG6cauCrCA+J02gidVsVUiwVHRfGvOtBYLWK9Mynuo2f5Ck4aQXoSSbAgriHgC8cCDfMdLZtKvbqr8RCVHmlhHcJ04bDHCFYJMjdc7TgtzW466rxs5U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779144120; c=relaxed/simple;
	bh=7rUJon7IG0Bs22ELxgCK4qBgYMCyLjnac+JvShP1g9Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Psui7JJNFHuBcBg/xWdE/lRxrRPmBQ8aHvH7yOy4+1JiYkGIZPcg3/7kIUbBgm9M3e1Umz8AT2Szu/nZi9s/dcKCrSdrTplXWD9UyYfbslUcc9luOzOYM6/CqUIm58vwUCum6y2sYXUdFaX7AP36OmyhDIkMOc2pEsH4srczO30=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=c4h8P07d; arc=pass smtp.client-ip=209.85.222.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ua1-f51.google.com with SMTP id a1e0cc1a2514c-95cd8b71105so1686322241.1
        for <live-patching@vger.kernel.org>; Mon, 18 May 2026 15:41:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779144117; cv=none;
        d=google.com; s=arc-20240605;
        b=lUK48iGik6rJoQjUq3XL2DsQZuQXrVyDAOxyas5dJ84PCjHcgbbuK75OSEmVoTMFyq
         uPBU+PVJ0zJd5HLDIUT+0Xj6rQrwq7mUmhcxP0DkhX7euMWThcR2hYsqoS5JZPKNw3xX
         tpUl0dJrrDV9d4PXM6mVEBSWxnmki/60G1M7YWNWlfO7ExK+terHsGgFTeDGENecdxOp
         vzqnZsS9oyr/ATRbHlsF6CJ88vZp6RK/ixekUcExxdBJ7xlVfu08/uDbK1k4n0BNMBW8
         o99F5yY0H+CwqJPqYSv4IqTyIhJ/j0Y3MGpmoid47IWtijkmn/sZYwvHX0slIw9eCI+M
         /8BQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=2JuphiYUJfrLeym0MaEZq4JVcplgaKtFBRjbJ+g8kmg=;
        fh=0bViMq+eaMXTwYss26l8W7Uepp3bQqGYkc9RxbiDygg=;
        b=lyuqjhoFIDV/wvvHIvmnr+psXJzzzzH/iJEUSDVjKZugcQvaRYN+5lu5RPhxNYnWvv
         hQOk5vSY/2DMK3IugXqpXf5oTG63TXrOjEyaQQdoIE06dtaZENjRz6m6YI4aiQPqOkoG
         0KbEFHpjx9AA4CYnvxkhNr/PY8YTDBApv2yLebjrvjNUUP9tgQaLnSSBntf9RHN06BZm
         AEQ8GbS3dqbRsBYMk8d+eowJZrjFieycqiPEbHf+lRnUiVGHZw0eaZL+S2kzuuVJvy5q
         1/jfcMhe1Ggf3Fusl3s8DXCFKBcQsm0MGUrWTOdFjkKN8T7nDdC2049/6onIAi4UF8t3
         aVlA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779144117; x=1779748917; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2JuphiYUJfrLeym0MaEZq4JVcplgaKtFBRjbJ+g8kmg=;
        b=c4h8P07dXfCVmTJCXOfg5LLS5PAJrgngALCUM8U3VGCwqbYF26LCnR3mRgsYZMJRK/
         9gtWz6rooy39Hl6c7bTykC763TMFw/vKESdpwVinmLq5rWScjIDobJGsW9yMPv13+N3U
         mjXQVou2uKEUE4ytfxuMqm79PLhObJnkEEiEtrD7GKjze2Y/UcyI/sS1lCO8j8kvv/u5
         qUq/ODqMGtAJAepDYL+6vDYD6OpFk1b29r0fnEiPcO1jk4yehxS9jz9+1QrejtdcD2E6
         e/a9FBCnLaft+/jEx+nhFmXuoDJaBbSXZCw41+3ZyFNgsW1x/b2TmacJIpYSJFj0LhDe
         O4Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779144117; x=1779748917;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2JuphiYUJfrLeym0MaEZq4JVcplgaKtFBRjbJ+g8kmg=;
        b=InQ/mSqvKa3XdpIMsmegU8BQStH1oFlWTSLVLUaxPxyl25OqcCSXBvP2EjNNKKZQ/v
         U3hi7bf4XCEWojRWk7ItQ0HSNosdf32mRwU3TPNj0gpwPFsin0MrOe8Tdaw0RIX/2oqS
         PAqzcr67HP7yJ0PtWLTYKnQ8Ut5VfP1641mOqv2WChesi3jfLMJBq/AqxFB8+wjQvJi+
         7OC58arzpQUgtCBJFQDTGhWE3sea/ctbAYl9t8XXgH4dq8v/YIffKcEcj3i6ESUaSBEG
         YN+xHQWPglMNDvCxRP1jsIPcttITdE4GHGrh2MF0/1w61rMhLrVhB4QFHVrAwaZX2ThO
         eN7Q==
X-Forwarded-Encrypted: i=1; AFNElJ+1NRmBLfRJIvMvLwAxHHklFf7VB23eFCLLVAjFgqlM33qD9lvQK4NBb4dW79VQsdV3BPNbHbt6bbQD+R2t@vger.kernel.org
X-Gm-Message-State: AOJu0Yw9LJvaxm4GG9pwNe5mT1qczswoUMUpdy134XIkHOHljOcXY9OD
	N8lpxrgpjxfpQK9eo1/UVc2K4EhGdlifl2UtQM8fbQb8ZTbn9hNTec2pLfM5CIwB5HPDPlUELRd
	NihGQAZExwk3rWberCaDfImuIPROPTQkgbU11vEXb
X-Gm-Gg: Acq92OHb3QLyxskpo3u7sSNnzBbnb0vuOuB8sTptmvN1x/1K6ow0YnfKc1Bpn007ncb
	iJ685LaY+Mz1sU11/i2FVw40wUOK0RgT09DjIr9NZu2m5WUlejmhjRm9Dla3rc4O57u4dcraI46
	8lSDY+0rCe+wmkeyMdsoTIsk6VNw86FnFKUR/onAWGA2Ye4GCN97rpQbOHjc4+SdvIg4Ir0IafO
	hbwDZFOEmZqT3ocfbozeokfPbVNiFxVgC1dQDYaOUvumjVXWMAOH3xhfIGQdfxM6jvsT4kn6K4K
	2sMFzbPwqmOgE5HD7cj6IkLkOlsE7z2is0QvRfqKW1m3Bbx6
X-Received: by 2002:a05:6102:1487:b0:610:6e69:5235 with SMTP id
 ada2fe7eead31-63a3f68e785mr9174240137.22.1779144116807; Mon, 18 May 2026
 15:41:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260428183643.3796063-1-dylanbhatch@google.com>
 <20260428183643.3796063-4-dylanbhatch@google.com> <afIjFLbUrdxWA6eR@J2N7QTR9R3.cambridge.arm.com>
 <CADBMgpxBeYUdA5X8BPgkgz=KQyN=NQ760bXygwXfvVRScNzgbA@mail.gmail.com> <agbgMb6jrgiFFHRX@J2N7QTR9R3>
In-Reply-To: <agbgMb6jrgiFFHRX@J2N7QTR9R3>
From: Dylan Hatch <dylanbhatch@google.com>
Date: Mon, 18 May 2026 15:41:44 -0700
X-Gm-Features: AVHnY4JsJwEnbtNc1imGWs0_F9EdyMGaAqb0DMHOauZ1DW1pqAw4WpJ61m0d9WE
Message-ID: <CADBMgpzppDZudqGZk94HrBB6yP2ZZeXVE0bkM1dJkZo0rVGCBQ@mail.gmail.com>
Subject: Re: [PATCH v5 3/8] arm64: entry: add unwind info for various kernel entries
To: Mark Rutland <mark.rutland@arm.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>, Weinan Liu <wnliu@google.com>, 
	Will Deacon <will@kernel.org>, Josh Poimboeuf <jpoimboe@kernel.org>, 
	Indu Bhagat <ibhagatgnu@gmail.com>, Peter Zijlstra <peterz@infradead.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Jiri Kosina <jikos@kernel.org>, Jens Remus <jremus@linux.ibm.com>, 
	Prasanna Kumar T S M <ptsm@linux.microsoft.com>, Puranjay Mohan <puranjay@kernel.org>, 
	Song Liu <song@kernel.org>, joe.lawrence@redhat.com, linux-toolchains@vger.kernel.org, 
	linux-kernel@vger.kernel.org, live-patching@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, Randy Dunlap <rdunlap@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2847-lists,live-patching=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[20];
	FREEMAIL_CC(0.00)[linux.dev,google.com,kernel.org,gmail.com,infradead.org,goodmis.org,arm.com,linux.ibm.com,linux.microsoft.com,redhat.com,vger.kernel.org,lists.infradead.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dylanbhatch@google.com,live-patching@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	TAGGED_RCPT(0.00)[live-patching];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
X-Rspamd-Queue-Id: 512DC574B63
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Fri, May 15, 2026 at 1:58=E2=80=AFAM Mark Rutland <mark.rutland@arm.com>=
 wrote:
>
> On Thu, May 14, 2026 at 08:30:43PM -0700, Dylan Hatch wrote:
> > On Wed, Apr 29, 2026 at 8:26=E2=80=AFAM Mark Rutland <mark.rutland@arm.=
com> wrote:
> > > On Tue, Apr 28, 2026 at 06:36:38PM +0000, Dylan Hatch wrote:
> > > > From: Weinan Liu <wnliu@google.com>
> > > >
> > > > DWARF CFI (Call Frame Information) specifies how to recover the ret=
urn
> > > > address and callee-saved registers at each PC in a given function.
> > > > Compilers are able to generate the CFI annotations when they compil=
e
> > > > the code to assembly language. For handcrafted assembly, we need to
> > > > annotate them by hand.
> > > >
> > > > Annotate minimal CFI to enable stacktracing using SFrame for kernel
> > > > exception entries through el1*_64_*() paths
> > >
> > > I thought we were only consuming SFrame when unwinding an exeption
> > > boundary?
> > >
> > > We shouldn't be taking exceptions _from_ the entry assembly functions
> > > unless something has gone horribly wrong, and so I don't see why we'd
> > > need CFI entries for the entry assembly functions.
> > >
> > > Am I missing some reason we need CFI entries for the entry assembly
> > > functions? I strongly suspect it is not necessary to add these, and I=
'd
> > > prefer to omit them.
> >
> > I believe the el1 entry functions are called in an exception, and are
> > called before call_on_irq_stack.
>
> Yes, but I don't think that matters. See below for more details.
>
> > Example stacktrace segment:
> >
> > [  262.119564]  handle_percpu_devid_irq+0xb4/0x348
> > [  262.119913]  handle_irq_desc+0x3c/0x68
> > [  262.120196]  generic_handle_domain_irq+0x20/0x40
> > [  262.120678]  gic_handle_irq+0x48/0xe0
> > [  262.121005]  call_on_irq_stack+0x30/0x48
> > [  262.121412]  do_interrupt_handler+0x88/0xa0
> > [  262.121779]  el1_interrupt+0x38/0x58
> > [  262.122089]  el1h_64_irq_handler+0x18/0x30
> > [  262.122617]  el1h_64_irq+0x6c/0x70
>
> The segment immediately above can be unwound using FP, as frame records
> were created consistently, and there are no exception boundaries. No CFI
> needed.

Ah right -- with the logic in stacktrace.c changed to use SFrame only
when recovering the next frame from a pt_regs, the FP alone is
sufficient if we know these entry functions won't take an exception.
This patch was originally implemented with an SFrame-only unwinder in
mind, so my mental model still hadn't back-propagated the new logic to
this patch :)

>
> It's legitimate to take an exception from parts of call_on_irq_stack(),
> so it makes sense for that to have CFI, but for the specific unwind
> segment above, CFI isn't necessary.
>
> Everything in the stacktrace segment above was executed *after* HW took
> the exception.
>
> << EXCEPTION BOUNDARY HERE >>
>
> Everything in the stacktrace segment(s) below was executed *before* HW
> took the exception.
>
> The unwinder knows that it has crossed this exception boundary by virtue
> of finding a FRAME_META_TYPE_PT_REGS frame record.
>
> > [  262.123159]  _raw_spin_unlock_irq+0x10/0x60 (P)
>
> The unwinder knows that the value of pt_regs::pc was *definitely* the PC
> at the time the exception was taken, so that entry is reliable. No CFI
> needed.
>
> > [  262.123720]  __filemap_add_folio+0x200/0x580 (L)
>
> The unwinder doesn't know whether the LR should be used, and needs CFI
> to determine that.
>
> After this point, an FP unwind can be used until we encounter the next
> exception boundary.

Right, and this is what is implemented in the final patch of this series.

>
> > [  262.124145]  filemap_add_folio+0xec/0x300
> > [  262.124674]  page_cache_ra_unbounded+0x128/0x368
> > [  262.125338]  do_page_cache_ra+0x70/0x98
> > [  262.125875]  page_cache_ra_order+0x460/0x4e0
>
> The segment immediately above can be unwound using FP. No CFI needed.
>
> > Here, el1h_64_irq is the last function that appears in the exception
> > stack before _raw_spin_unlock_irq and __filemap_add_folio are
> > recovered from the saved PC and LR, respectively. So we therefore need
> > the CFI annotations in order to unwind through the full exception
> > boundary.
> >
> > Is my interpretation here correct?
>
> Given you say "full exception boundary" here, I think we might be using
> the term "exception boundary" to mean different things.
>
> As per the example above, I'm using "exception boundary" to mean the a
> point between two entries in the stacktrace where HW took an exception.
>
> Did my comments on the example help?

I admit I may have been using the term "exception boundary" with a
vague definition, which was partly the source of my confusion. Thanks
for the example, it did help.

>
> > > > and irq entries through call_on_irq_stack()
> > >
> > > Needing some sort of unwind annotations for call_on_irq_stack() makes
> > > sense to me, but don't we need something for other assembly functions
> > > too?
> > >
> > > We can interrupt things like memset(); I assume we'll treat those as
> > > unreliable until annotated?
> >
> > While looking into adding these annotations, I noticed a pattern where
> > a sibling call is made to a local function:
> >
> > SYM_FUNC_START(__pi_memset)
> > alternative_if_not ARM64_HAS_MOPS
> >         b       __pi_memset_generic
> > alternative_else_nop_endif
> >
> >         mov     dst, dstin
> >         setp    [dst]!, count!, val_x
> >         setm    [dst]!, count!, val_x
> >         sete    [dst]!, count!, val_x
> >         ret
> > SYM_FUNC_END(__pi_memset)
> >
> > In this case, do we consider the stacktrace unreliable since
> > __pi_memset may not appear in the trace?
>
> This is a tail-call, and __pi_memset_generic() will not return to
> __pi_memset(). Once the branch to __pi_memset_generic() has been
> executed, it's fine for __pi_memset() to not show up in the trace.
>
> The key thing is that no more instructions from __pi_memset() itself
> will be executed unless it was called again (from its entry point).
>
> > Or is this not important because assembly functions cannot be directly
> > livepatched anyway?
>
> To the best of my knowledge, reliable stacktrace is only used to
> determine whether any thread is still within an old version of a
> patchable function (including where it's within a callee thereof).
>
> I am not aware of a case where we'd need to detect whether a thread is
> still within a non-patchable function, but I can't rule out that as a
> possibility.
>
> That's more of a question for the livepatching maintainers.
>
> Thanks,
> Mark.

Thanks,
Dylan

