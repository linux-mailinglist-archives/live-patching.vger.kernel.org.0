Return-Path: <live-patching+bounces-2831-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id juEZBnWTBmrskwIAu9opvQ
	(envelope-from <live-patching+bounces-2831-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 15 May 2026 05:31:01 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A55E548F89
	for <lists+live-patching@lfdr.de>; Fri, 15 May 2026 05:30:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4FFC830214E7
	for <lists+live-patching@lfdr.de>; Fri, 15 May 2026 03:30:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7808342CB6;
	Fri, 15 May 2026 03:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vEVQRir6"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-ua1-f52.google.com (mail-ua1-f52.google.com [209.85.222.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 524EC1B4224
	for <live-patching@vger.kernel.org>; Fri, 15 May 2026 03:30:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778815857; cv=pass; b=dnDwxqTobLZnUb0usNyKQ2oHoAMrNKY0HEtAcbpM8ACo6rD0ZeFO/d42IzsNdrH8+Rkb3DQFZ+YxZCfSz5/V2jawFt8h1v2iIfSYCKQzgUCuU4N10EguCGj/j5LHeMxC1q+gSzKe2qjcp+TxSWuQL+RmWAB3qB+9ZwDfONkY7t8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778815857; c=relaxed/simple;
	bh=SyLq6l03Jbv77EGiuhHzi5QbP6fsi2oew2GbbqSsrAY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aBbqZmGz2v5zK5qmyBwROHTNIm1EFD1KOVxFSiE5GpvFEHXLdwk7F62+4w8yqeEHlLQDt72nX6xly/wcMOLgDzVu5z/Of9hedk0Ge7Q3gQmuTgQ9+DrL0FzH+pWpGUSS1h8lbyluW5xTlZPakrNS77XV9T5EyXdbk4amDKolbHk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vEVQRir6; arc=pass smtp.client-ip=209.85.222.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ua1-f52.google.com with SMTP id a1e0cc1a2514c-95cd9a5f24cso2584956241.2
        for <live-patching@vger.kernel.org>; Thu, 14 May 2026 20:30:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778815855; cv=none;
        d=google.com; s=arc-20240605;
        b=YxLpDQNDyiWxFi1z/7HSMIQZ5a9Y499D41oChjcsVocS2EeCEyT7blPRfbQ7Ry74OL
         ZZXfczepWmoilB0F7pISctycPAAgDqEjqVR2+kxzGKkPzftPM4BNg6VUSy5bqrXEvVQN
         GpAeQSvItKu7Zi1D8aRcSTu62HOTehKEh3CHJ9PuMRKEdIqR+xHX3vTbyi2HWV0ivT6P
         TAa5P2DZ1YWD4NbakRz+CZLctqHT79SXvu6Mv5b+FXiWzYcGwi/eWBsmYJZksDQiHioH
         6ZbZwbZU/W/50mQfFDWWqMIcrcux2ro55dWJl6Dhu37Zms3IzNJzthYPEq5QXi1JHLji
         ZIZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Fop7pjzudS6D7wpF5+eicnKfmSm+O2A+twiw3O1334U=;
        fh=A3Cp9EbF4GVdIDGc5OPyME7QkSNFjYWl3MYyuUVfRv0=;
        b=VNrUO2MYKowd7pZ2Obe819Q2XtTSRyjcOhHyet/5HP2r33Hi255VnQU4QPRGL73qor
         sX5ayF4BiCnfJMYjzhOh1/iYACNpIHMkcWcuuwjazX/NQxWiIxhg33p6n+mUTxCF7xgs
         iSKwv7dNw/PdS5nbPoIkDGNENnAMH7zgmC+ZKEOz/u+jO0Zs44VarsYhHFs5FbtI77O/
         s0XvIG2RcyTqkIqYCsfRJMmL64/LHkGX4WwhpgzRZrwjsGovTYJGXJOSa4w0KdOzFxU0
         an/qqCjXS3xeydAVBaAKyZyVD4NQPD/DSpkMo/aqoYSAQv/RmD9fabnYqbVUP8nR7LA0
         mlWQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778815855; x=1779420655; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Fop7pjzudS6D7wpF5+eicnKfmSm+O2A+twiw3O1334U=;
        b=vEVQRir6Acr0E69jX1tzjWAC7tpXbJC5B78UOSM6fTOlnx9qQeMsmNxD5li+7fhIlW
         7l1CsA4EGpj3fyrvKu9q85od5sXrdS+RJgyd2fIXBk+gWGo6ii7kMQaFW8fHrOiGpKKE
         pvBqIwMwQ5fbscEUrzW0xfra7vKboxZqZyVXQmB/pbKGsnF4zORbNgPC1j3zcwbMJlSO
         oR4uGjYPUwM9hoBbUpJE4fXHpU4hZpo6moXesZlFmRK8rLlCTXo8JIkchCFqpVFtqg32
         38Nbez5yEXz0RdsgGKjWpdDqvqbyhewsjhbZGEXtc7ruoaoPV+dK16uXU178UW1IqBU8
         Y8Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778815855; x=1779420655;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Fop7pjzudS6D7wpF5+eicnKfmSm+O2A+twiw3O1334U=;
        b=Wox9dsNaK06tJq6cVuFG1vdBwNX5Ekxd8gwLaffCrKuJuffLvHTjKRn4BE6zFUeNAC
         e73ncgrJwE6x4aFh7Ry/KQ9rN1QhPg0PLw+GZIMaPk55Vav7C5oHGqhHbmhSCeiAwRs2
         u3p1DLhQA8rQn6OsLxaytU+OnmrsAnpMW1o7Qz5oHM82D3n2HFTA1xDgB5Dx41fHqUwI
         8eGdvCA2inr3nnxUnpSTr4iF8k8pxSy7Mw2dzY+jNxQ/9zgZta1cu7uvv9otNPNV4FEl
         idjJDp/qdtdfkUwfFFRf9U00OvaMcY6yCb7wkEvg85CbEJdYUmvikt29UZ8NNBLeT0x4
         asGw==
X-Forwarded-Encrypted: i=1; AFNElJ+nb+Cpf4G9L1tDjJVXbnt/8h78WgHfbOziSjUCCb5VM3FSaTjltNwiwRTWXrnLoUJ0KI57oP9py8+lgnNl@vger.kernel.org
X-Gm-Message-State: AOJu0Yxzde8kRKpoE9IxB2G3LPprga6ROQvrmg2vIhAvDxOd47CtFeEA
	1G0vATPZbDDj9ITWTshsiHexOAQEEfuwM52SQHf1wGyDSYwOXjCPdUOFGm0wCX8tQRPmFXuvaK8
	T5HZRxgen2hrrQlDsF3wkizzQSWS2h/jF0WpZs9W5
X-Gm-Gg: Acq92OFtAklPrMOibqHJ5Ons82cgP9ZvIs3XC1Up4zT0j4lu4D3H2IWNdmRS+nHjsHW
	6Euoz6ZFi4cJiW0J3bYUJXdNWNR3kLgEw6Bzt8AwAoMmKk6zjZH+T0jC0dbHc/kkyisG+U9l5S5
	QdteUNOlrSkaak5HP0ArxY1pTV7inweBe/xZLMSaEaaBoZEP5pkp1Eil7slBzMI3piRabQYkRet
	jau4WD3CrPdJoxdIAgXEB4rIuHq0+Q5AVammvaH2c/LflPGPdSiCa3Bpi2rp5zQbOhhEGj2qz1t
	w2KmXODHy8SqLUmoVg==
X-Received: by 2002:a05:6102:1625:b0:631:2dc6:2f5c with SMTP id
 ada2fe7eead31-63a39b64e5cmr1060585137.0.1778815854791; Thu, 14 May 2026
 20:30:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260428183643.3796063-1-dylanbhatch@google.com>
 <20260428183643.3796063-4-dylanbhatch@google.com> <afIjFLbUrdxWA6eR@J2N7QTR9R3.cambridge.arm.com>
In-Reply-To: <afIjFLbUrdxWA6eR@J2N7QTR9R3.cambridge.arm.com>
From: Dylan Hatch <dylanbhatch@google.com>
Date: Thu, 14 May 2026 20:30:43 -0700
X-Gm-Features: AVHnY4IjCZOnrcRB6EchAvXRAgsUMT_fI25-8QVgnLQEfY3rQYsW4VZ_r7tS_bA
Message-ID: <CADBMgpxBeYUdA5X8BPgkgz=KQyN=NQ760bXygwXfvVRScNzgbA@mail.gmail.com>
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
X-Rspamd-Queue-Id: 5A55E548F89
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2831-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[linux.dev,google.com,kernel.org,gmail.com,infradead.org,goodmis.org,arm.com,linux.ibm.com,linux.microsoft.com,redhat.com,vger.kernel.org,lists.infradead.org];
	RCPT_COUNT_TWELVE(0.00)[20];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dylanbhatch@google.com,live-patching@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[live-patching];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,mail.gmail.com:mid]
X-Rspamd-Action: no action

On Wed, Apr 29, 2026 at 8:26=E2=80=AFAM Mark Rutland <mark.rutland@arm.com>=
 wrote:
>
> Hi Dylan,
>
> On Tue, Apr 28, 2026 at 06:36:38PM +0000, Dylan Hatch wrote:
> > From: Weinan Liu <wnliu@google.com>
> >
> > DWARF CFI (Call Frame Information) specifies how to recover the return
> > address and callee-saved registers at each PC in a given function.
> > Compilers are able to generate the CFI annotations when they compile
> > the code to assembly language. For handcrafted assembly, we need to
> > annotate them by hand.
> >
> > Annotate minimal CFI to enable stacktracing using SFrame for kernel
> > exception entries through el1*_64_*() paths
>
> I thought we were only consuming SFrame when unwinding an exeption
> boundary?
>
> We shouldn't be taking exceptions _from_ the entry assembly functions
> unless something has gone horribly wrong, and so I don't see why we'd
> need CFI entries for the entry assembly functions.
>
> Am I missing some reason we need CFI entries for the entry assembly
> functions? I strongly suspect it is not necessary to add these, and I'd
> prefer to omit them.

I believe the el1 entry functions are called in an exception, and are
called before call_on_irq_stack. Example stacktrace segment:

[  262.119564]  handle_percpu_devid_irq+0xb4/0x348
[  262.119913]  handle_irq_desc+0x3c/0x68
[  262.120196]  generic_handle_domain_irq+0x20/0x40
[  262.120678]  gic_handle_irq+0x48/0xe0
[  262.121005]  call_on_irq_stack+0x30/0x48
[  262.121412]  do_interrupt_handler+0x88/0xa0
[  262.121779]  el1_interrupt+0x38/0x58
[  262.122089]  el1h_64_irq_handler+0x18/0x30
[  262.122617]  el1h_64_irq+0x6c/0x70
[  262.123159]  _raw_spin_unlock_irq+0x10/0x60 (P)
[  262.123720]  __filemap_add_folio+0x200/0x580 (L)
[  262.124145]  filemap_add_folio+0xec/0x300
[  262.124674]  page_cache_ra_unbounded+0x128/0x368
[  262.125338]  do_page_cache_ra+0x70/0x98
[  262.125875]  page_cache_ra_order+0x460/0x4e0

Here, el1h_64_irq is the last function that appears in the exception
stack before _raw_spin_unlock_irq and __filemap_add_folio are
recovered from the saved PC and LR, respectively. So we therefore need
the CFI annotations in order to unwind through the full exception
boundary.

Is my interpretation here correct?

>
> > and irq entries through call_on_irq_stack()
>
> Needing some sort of unwind annotations for call_on_irq_stack() makes
> sense to me, but don't we need something for other assembly functions
> too?
>
> We can interrupt things like memset(); I assume we'll treat those as
> unreliable until annotated?

While looking into adding these annotations, I noticed a pattern where
a sibling call is made to a local function:

SYM_FUNC_START(__pi_memset)
alternative_if_not ARM64_HAS_MOPS
        b       __pi_memset_generic
alternative_else_nop_endif

        mov     dst, dstin
        setp    [dst]!, count!, val_x
        setm    [dst]!, count!, val_x
        sete    [dst]!, count!, val_x
        ret
SYM_FUNC_END(__pi_memset)

In this case, do we consider the stacktrace unreliable since
__pi_memset may not appear in the trace? Or is this not important
because assembly functions cannot be directly livepatched anyway?

Thanks,
Dylan

