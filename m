Return-Path: <live-patching+bounces-1230-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 15D9CA4510A
	for <lists+live-patching@lfdr.de>; Wed, 26 Feb 2025 00:55:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 27B8C3A9235
	for <lists+live-patching@lfdr.de>; Tue, 25 Feb 2025 23:54:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AB83236430;
	Tue, 25 Feb 2025 23:54:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ivuBa7xf"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B0202153FE
	for <live-patching@vger.kernel.org>; Tue, 25 Feb 2025 23:54:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740527699; cv=none; b=QuHgFpxpamTIka0W4bIWQj3DasLATZ6VJczneN0TeGouhdJnrNWiLEB0Xfo3RMHoRXwTt1vyREZE4hzH3qnVGPrdBdSOQQ95pkIS3fs5FAWsSUkDduZOakIHe2fW9sWWXM5+deDlijaRBsmsbz5kJ/WKI/npII1xHDdt6Uxi02k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740527699; c=relaxed/simple;
	bh=pxdC/62rAoRuJSWlwmGhWe4xUiKN8iX0091lT7RGSzg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=aXzFSpOLpLD+cacipT4OPJ8noqIdny3mYgT/OV+S/b/ctimuXq9WWPH46kxVkfHTOtF4NMneenAGZ2kELQTrdhDf3G0SZcz5OZg9WH1ztMbR3KPmmIRTFW+gdwPMwqz7oxHR5aKv+D8JwD7y+WrNDUWm1YFZRqeKzrFt/hjhiL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--wnliu.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ivuBa7xf; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--wnliu.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2217a4bfcc7so129729845ad.3
        for <live-patching@vger.kernel.org>; Tue, 25 Feb 2025 15:54:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740527697; x=1741132497; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pxdC/62rAoRuJSWlwmGhWe4xUiKN8iX0091lT7RGSzg=;
        b=ivuBa7xfJ9XVpv0hyJZ7/B0T0TdRcRWLi6+5ZtKkNyDR8w07y6F1O9kf/3dvEvBDzc
         R8TsQsKlGTDsXPRSZ0SgmDN2TCjXJlfkvzq7IJmmnaBuWEwxPUT/wCV+PTJlGJrEHRoS
         TPIUZWajdbAzc7RuCYKi0FawDiAWc32nKi7stjZs+xSXZVqXOop84BrW3RRGmSZK8FOO
         HTKPfIjd3DVkGlJo8YMen8EKGspvzAblA5AQnFrZ7f7V+juWXUdkyAFeQim6VXH+gBMH
         Sg7HM3SjovhRvDBNGdYLYK8Kldc7Mm31co3q+aDo5+78bWXdZvAf3VD8C031siYOyPit
         Wc9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740527697; x=1741132497;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=pxdC/62rAoRuJSWlwmGhWe4xUiKN8iX0091lT7RGSzg=;
        b=anr0y6zt8ExFTJnmvV+981hUoAnzqmneBDk1kplJmjqG7d0OIiOMx8DeHYkBxSQeWh
         mgR4qgd2UOHRBCZx1tyd22ZVqEygnS9fsy8IDiimLs2jIeF6PwVgpOtfmNTD3ep5Imkx
         l3CbwTFBFPj2+2iCY9G6AXiyPaOr7rPwjDQ6ZMGeSKqKqC67pbqY7q869kUnZWsZ3O5q
         vBAK1TzbOB/4GZx/XU3BcloSGn+f0tpEn2Wd0weN1wZYnTuZESZWmWOKm3sAlSyntxgx
         cHSl0sjbGhIklwZhiBMoyjtJUblOH6gMI3HEbLwJCb8F5BNExFfkR+t2V53KGSd8UGaF
         kjKw==
X-Forwarded-Encrypted: i=1; AJvYcCVWTpAKHIniJOuDOhZcUwY5BFN25A3aqhVWZJVZ0LuFn1I2SvNNbZGYvKHKzRsYDNiOu7+vowY5iOY/IYGv@vger.kernel.org
X-Gm-Message-State: AOJu0Yx0/iV+q4UZjf58Q1EUOsi7i116keHG8WAVuuSVz1H4rPXZepv4
	EyKsGGm2UIBLLfGfU/JQGaQQ3h8JsgkSWnau7IZ7q/f5CdbYxjCb32LZwSUNo34Bk/u3HZm4Kw=
	=
X-Google-Smtp-Source: AGHT+IGm7OlvsiRCbKMLn2MJybb+vZ4eGRwGa0mzKMAShvASY73Heo8D8O95riW5nBaMdjkiDwddH2xcSg==
X-Received: from pljj1.prod.google.com ([2002:a17:902:c3c1:b0:220:ca3c:96bb])
 (user=wnliu job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:f60a:b0:21f:752f:f2b1
 with SMTP id d9443c01a7336-221a1102975mr274878155ad.30.1740527696921; Tue, 25
 Feb 2025 15:54:56 -0800 (PST)
Date: Tue, 25 Feb 2025 23:54:54 +0000
In-Reply-To: <4356c17a-8dba-4da0-86dd-f65afb8145e2@oracle.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <4356c17a-8dba-4da0-86dd-f65afb8145e2@oracle.com>
X-Mailer: git-send-email 2.48.1.658.g4767266eb4-goog
Message-ID: <20250225235455.655634-1-wnliu@google.com>
Subject: Re: [PATCH 0/8] unwind, arm64: add sframe unwinder for kernel
From: Weinan Liu <wnliu@google.com>
To: indu.bhagat@oracle.com
Cc: irogers@google.com, joe.lawrence@redhat.com, jpoimboe@kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-toolchains@vger.kernel.org, live-patching@vger.kernel.org, 
	mark.rutland@arm.com, peterz@infradead.org, puranjay@kernel.org, 
	roman.gushchin@linux.dev, rostedt@goodmis.org, will@kernel.org, 
	wnliu@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 25, 2025 at 11:38=E2=80=AFAM Indu Bhagat <indu.bhagat@oracle.co=
m> wrote:
>
> On Mon, Feb 10, 2025 at 12:30=E2=80=AFAM Weinan Liu <wnliu@google.com> wr=
ote:
> >> I already have a WIP patch to add sframe support to the kernel module.
> >> However, it is not yet working. I had trouble unwinding frames for the
> >> kernel module using the current algorithm.
> >>
> >> Indu has likely identified the issue and will be addressing it from th=
e
> >> toolchain side.
> >>
> >> https://sourceware.org/bugzilla/show_bug.cgi?id=3D32666
> >
> > I have a working in progress patch that adds sframe support for kernel
> > module.
> > https://github.com/heuza/linux/tree/sframe_unwinder.rfc
> >
> > According to the sframe table values I got during runtime testing, look=
s
> > like the offsets are not correct .
> >
>
> I hope to sanitize the fix for 32666 and post upstream soon (I had to
> address other related issues). =C2=A0Unless fixed, relocating .sframe
> sections using the .rela.sframe is expected to generate incorrect output.
>
> > When unwind symbols init_module(0xffff80007b155048) from the kernel
> > module(livepatch-sample.ko), the start_address of the FDE entries in th=
e
> > sframe table of the kernel modules appear incorrect.
>
> init_module will apply the relocations on the .sframe section, isnt it ?
>
> > For instance, the first FDE's start_addr is reported as -20564. Adding
> > this offset to the module's sframe section address (0xffff80007b15a040)
> > yields 0xffff80007b154fec, which is not within the livepatch-sample.ko
> > memory region(It should be larger than 0xffff80007b155000).
> >
>
> Hmm..something seems off here. =C2=A0Having tested a potential fix for 32=
666
> locally, I do not expect the first FDE to show this symptom.
>

Yes, I think init_module will apply the relocation as well.
To further investigate, here's the relevant relocation and symbol table
information for the kernel module:

Relocation section '.rela.sframe' at offset 0x28350 contains 3 entries:
=C2=A0 Offset =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Info =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 Type =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Sym. Value =C2=A0 =C2=
=A0Sym. Name + Addend
00000000001c =C2=A0000100000105 R_AARCH64_PREL32 =C2=A00000000000000000 .te=
xt + 8
000000000030 =C2=A0000100000105 R_AARCH64_PREL32 =C2=A00000000000000000 .te=
xt + 28
000000000044 =C2=A0000100000105 R_AARCH64_PREL32 =C2=A00000000000000000 .te=
xt + 68

Symbol table '.symtab' contains 68 entries:
=C2=A0 =C2=A0Num: =C2=A0 =C2=A0Value =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Size=
 Type =C2=A0 =C2=A0Bind =C2=A0 Vis =C2=A0 =C2=A0 =C2=A0Ndx Name
=C2=A0 =C2=A0 =C2=A00: 0000000000000000 =C2=A0 =C2=A0 0 NOTYPE =C2=A0LOCAL =
=C2=A0DEFAULT =C2=A0UND
=C2=A0 =C2=A0 =C2=A01: 0000000000000000 =C2=A0 =C2=A0 0 SECTION LOCAL =C2=
=A0DEFAULT =C2=A0 =C2=A01 .text
...
=C2=A0 =C2=A0 32: 0000000000000008 =C2=A0 =C2=A012 FUNC =C2=A0 =C2=A0LOCAL =
=C2=A0DEFAULT =C2=A0 =C2=A01 livepatch_exit
=C2=A0 =C2=A0 33: 0000000000000008 =C2=A0 =C2=A0 0 NOTYPE =C2=A0LOCAL =C2=
=A0DEFAULT =C2=A0 =C2=A03 $d
=C2=A0 =C2=A0 34: 0000000000000028 =C2=A0 =C2=A044 FUNC =C2=A0 =C2=A0LOCAL =
=C2=A0DEFAULT =C2=A0 =C2=A01 livepatch_init
=C2=A0 =C2=A0 35: 0000000000000000 =C2=A0 =C2=A0 0 NOTYPE =C2=A0LOCAL =C2=
=A0DEFAULT =C2=A0 =C2=A09 $d
=C2=A0 =C2=A0 36: 0000000000000010 =C2=A0 =C2=A0 0 NOTYPE =C2=A0LOCAL =C2=
=A0DEFAULT =C2=A0 =C2=A03 $d
=C2=A0 =C2=A0 37: 0000000000000068 =C2=A0 =C2=A056 FUNC =C2=A0 =C2=A0LOCAL =
=C2=A0DEFAULT =C2=A0 =C2=A01 livepatch_cmdlin[...]
...
=C2=A0 =C2=A0 63: 0000000000000008 =C2=A0 =C2=A012 FUNC =C2=A0 =C2=A0GLOBAL=
 DEFAULT =C2=A0 =C2=A01 cleanup_module
=C2=A0 =C2=A0 64: 0000000000000000 =C2=A0 =C2=A0 0 NOTYPE =C2=A0GLOBAL DEFA=
ULT =C2=A0UND klp_enable_patch
=C2=A0 =C2=A0 65: 0000000000000028 =C2=A0 =C2=A044 FUNC =C2=A0 =C2=A0GLOBAL=
 DEFAULT =C2=A0 =C2=A01 init_module

