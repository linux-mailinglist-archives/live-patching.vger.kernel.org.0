Return-Path: <live-patching+bounces-1858-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B39CC600A0
	for <lists+live-patching@lfdr.de>; Sat, 15 Nov 2025 07:44:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C77C33BE4CE
	for <lists+live-patching@lfdr.de>; Sat, 15 Nov 2025 06:44:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF9AF1FBC92;
	Sat, 15 Nov 2025 06:44:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WmftFowl"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-ua1-f42.google.com (mail-ua1-f42.google.com [209.85.222.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C5BF1917ED
	for <live-patching@vger.kernel.org>; Sat, 15 Nov 2025 06:44:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763189073; cv=none; b=umLdVPAncvEyZSeQhFibVISJ+ZFHpSlu+MBSL9b4S7DV8GIk1MdIKGb6R+DMX+1gbTUaqir0D0lcGWRpaFpOuh3H3aPipanp3MMyIFQ6zwhRJMQ/Sbhs9MY4MyZZCVgMCqc+FPp5qj1Py6OaAc45S8YAOnoNSM4okC6GxsroHfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763189073; c=relaxed/simple;
	bh=dNQppL3S/rPtDJm3ci5s2VLa/EqCej1o9wKVfCADkdE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HZlgxurkl4sY0o88bu1axrunA6pok8PJ7/slmqi4gurKzzraKaDqGx/BmB0HXaE2qnXfc4GKNLLnI59C80YETbZ4TVy/ztm5lbQT99i89s+FQyvewKfh9zYMN/CWDF4ykjoADdIoiObXWZsq6JzIejZi3WpooaVzJ7N9fa4l4PU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WmftFowl; arc=none smtp.client-ip=209.85.222.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ua1-f42.google.com with SMTP id a1e0cc1a2514c-93722262839so1515645241.2
        for <live-patching@vger.kernel.org>; Fri, 14 Nov 2025 22:44:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763189071; x=1763793871; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HwC49H0o3FxJV5icz/5NCk5PlqmOiKiZHnb9jvksA8c=;
        b=WmftFowlLT9uZwgogqTJZNtlOxUp0fiOwlGZIKPxxALrrh7GAHODX2MxdABI6myKWd
         lGNqJNV2AZ8muV3CJN/qF5mE0uJzBXItI+wNviEPeR92TaRkJQcAKvjbdp6GNMWOWk8o
         xxmyLPgG05l35bXNXdwCl8xQM48TuPH0ItMV5WEnZBJYSrDOpkTR2JpkiKtokzIcHDFr
         fmRhH2c38RwQaBWnZVUhLKcHJimYaR1OoM0foSAG6RgQscwifA8RmTgTXcROBi4tIjtr
         TFvmD4ARo0h1S2jbr4sWM8Fkhr2SOuvp9d+50zssju0zx3xRV1BgyybcKtLqhVCYzeyg
         97TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763189071; x=1763793871;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=HwC49H0o3FxJV5icz/5NCk5PlqmOiKiZHnb9jvksA8c=;
        b=MdsG+AV5yvBqKMl/KuOhUrlEPYyhm7BNt7bec6DtNSxlO+6lrfQV4V5M5lXxctc8+D
         +ikWCRNuaAZBtZzA/6xk72GssE60Z2AQ2urQZIDd7ZYcvsRWaGANdq8U6JJuJoUnM4Qs
         Iq2PoTsBtwSDg38BnYEGtsJl3BjJowbveMCNcXNh3I13IhWhQstY6QAastsuoPwJ0Vai
         RP/tMzXN9yy5q9YngvZMdadoNtfEspuSxG272deK09EHbksOgaT8iWqMx/QKA6vD2Kgo
         sWyKLxy0nA7GyAeANZHjKZGbcIN7jsMX2Mm6bWFcoOyIlyLgNRnMRmXh1KpQW1AJstoe
         T5iw==
X-Forwarded-Encrypted: i=1; AJvYcCVlPWWDbh/h2Q7BQi2vftdzu5y02ouEDDMquHQ9wVtpcMnlKxk+vGgmiUqgxQeSmOFKEa3hQJ6fKR4G5sIM@vger.kernel.org
X-Gm-Message-State: AOJu0YwXi2udM4bmRuzVtHBWfL6Ex+odBpI3hELRxAfqlhT+uSwtfetM
	/uwa+FdC+KOdoc2NHwufgnPxNwIcxSdziiZFo+Ykkmxn0BGENsnKDKz+HHPMSMeMzEKBSTR0Ai/
	fETeavLqtxA9KTkBCke8WPIw16wm+MEalF9iTNx5Q
X-Gm-Gg: ASbGncsZ/TwvxCRoMwUuzm3MVGt4CwiuUHIbjY3trjg474hKkaN6kqg/UBcqzzvD01F
	d7RSqfs+7mxbj9/XllwKGSytZ9Wn3jSrqEp5wsQAZHrBnYn0uQd4sI8318Zk583eRglokTrWnOG
	AN0c58Tyuc3PxIppjPctblKY+i3ihERPaKhAh9Ydwftorv5pp2HfQG3sv84W+qXj3YPzgL7+OE2
	L8tblCJ7qUBIqrNcLKD12tzDj74y7PSms2QZKeGhiEkX2l409y7H4imPcRoECC4TcFaptw0jbsL
	xKY2kw==
X-Google-Smtp-Source: AGHT+IGQuyvvCrY2FskJ9sdLQkXe0RTkOG8d3VDv4bzvAdawM6Rdu6JP8by+xzyV3l/P8ABbnCZCKZMTQxZJfNCf6BU=
X-Received: by 2002:a05:6102:41a2:b0:5db:d60a:6b1f with SMTP id
 ada2fe7eead31-5dfc5b727cbmr2280150137.23.1763189070999; Fri, 14 Nov 2025
 22:44:30 -0800 (PST)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250904223850.884188-1-dylanbhatch@google.com>
 <20250904223850.884188-7-dylanbhatch@google.com> <xo2ro446awhsd7i55shx6tlz6s2azuown4xk6zfm7ie4zz2nqc@244onpurkvy3>
In-Reply-To: <xo2ro446awhsd7i55shx6tlz6s2azuown4xk6zfm7ie4zz2nqc@244onpurkvy3>
From: Dylan Hatch <dylanbhatch@google.com>
Date: Fri, 14 Nov 2025 22:44:20 -0800
X-Gm-Features: AWmQ_bkkQw_rgL15OTp3r5_njXzYzXc7yIV8EJr04RBS3D5gpBl8zHwupKkVqVU
Message-ID: <CADBMgpyVis+fRHLOv6BRPrT+0r8846MOutkmOgMbqytLVXh9Ag@mail.gmail.com>
Subject: Re: [PATCH v2 6/6] unwind: arm64: Add reliable stacktrace with sframe unwinder.
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Indu Bhagat <indu.bhagat@oracle.com>, 
	Peter Zijlstra <peterz@infradead.org>, Will Deacon <will@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Jiri Kosina <jikos@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Weinan Liu <wnliu@google.com>, 
	Mark Rutland <mark.rutland@arm.com>, Ian Rogers <irogers@google.com>, 
	linux-toolchains@vger.kernel.org, linux-kernel@vger.kernel.org, 
	live-patching@vger.kernel.org, joe.lawrence@redhat.com, 
	Puranjay Mohan <puranjay@kernel.org>, Song Liu <song@kernel.org>, 
	Prasanna Kumar T S M <ptsm@linux.microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Sorry for the slow reply on this, I'm going to try and get a v3 out
sometime after next week.

On Wed, Sep 17, 2025 at 4:41=E2=80=AFPM Josh Poimboeuf <jpoimboe@kernel.org=
> wrote:
>
> As far I can tell, the *only* error condition being checked is if it
> (successfully) fell back to frame pointers.

By checking/handling error conditions, do you mean just marking the
state as unreliable in any case where the unwind isn't successful with
SFrame? I'm thinking if I can make the unwind_next_frame_sframe() code
path handle the end of the stack correctly on its own, I can more
strictly mark the trace as unreliable if it encounters any error.

>
> What if there was some bad or missing sframe data?  Or some unexpected
> condition on the stack?
>
> Also, does the exception handling code have correct cfi/sframe metadata?
>
> In order for it to be "reliable", we need to know the unwind reached the
> end of the stack (e.g., the task pt_regs frame, from entry-from-user).

It looks like the frame-pointer based method of handling the end of
the stack involves calling kunwind_next_frame_record_meta() to extract
and check frame_record_meta::type for FRAME_META_TYPE_FINAL. I think
this currently assumes (based on the definition of 'struct
frame_record') that the next FP and PC are right next to each other,
alongside the meta type. But the sframe format stores separate entries
for the FP and RA offsets, which makes extracting the meta type from
this information a little bit murky to me.

Would it make sense to fall back to the frame pointer method for the
final stack frame? Or I guess I could define a new sframe-friendly
meta frame record format?

Thanks,
Dylan

