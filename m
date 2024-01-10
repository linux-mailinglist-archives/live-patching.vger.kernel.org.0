Return-Path: <live-patching+bounces-128-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B91A829E9B
	for <lists+live-patching@lfdr.de>; Wed, 10 Jan 2024 17:28:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 234B41C20FFD
	for <lists+live-patching@lfdr.de>; Wed, 10 Jan 2024 16:28:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 777DB4CB30;
	Wed, 10 Jan 2024 16:28:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="KlvZl50N"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com [209.85.208.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98A6D4439B
	for <live-patching@vger.kernel.org>; Wed, 10 Jan 2024 16:28:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-2cd64022164so31087711fa.3
        for <live-patching@vger.kernel.org>; Wed, 10 Jan 2024 08:28:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1704904120; x=1705508920; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:to:from:subject:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Cs+UoTX+zzFiaZK+EYqQpy8idd/6cK/MXkjJcC/YZqw=;
        b=KlvZl50Nmf1AJ5h9wrd0bhtFZ50z11b0Y4ST7dUDlBJSKKsFYpG+74Yi56fpjWFeWg
         IeKRc5I7SBR3GBAMQTqsCsKrhxgiEbwVrg2AkM1qUovaIfDQFYHVI57ZvOXYMNsL9UzN
         eXymqR3bofORt2XASXeSNHuD/uAT9AzrzXDJem45ertCNMW8f6Aqn44ccBwa7xijNhAC
         i7UCmqhJ/gdVzUJB88bNQS5MCUrZZhmelbucXFut5CX4BHTRtWvGSMCUxC2WaIS4E91/
         ID2xNfjL/z9SVmBWBVd9fvf+lMWethVn6YNkHpW3imLGxgdD4cFYRlYshDX2oRUKs7jw
         weoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704904120; x=1705508920;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:to:from:subject:message-id:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Cs+UoTX+zzFiaZK+EYqQpy8idd/6cK/MXkjJcC/YZqw=;
        b=CMUksQMPT7HfTwiknmbrQ5kfciq9koc/8s+7mkjMbjcJRzwBu2221dP9jNO3yvDe18
         Sqw9jWs3mhE+taDbd1mEP/03Cz7irQR/IScMENotFaB2jWY1PGQp2GRdY86wMUWEDmUz
         fy1GTC6M5DXqQ3FTE02bU1/xNGxFxBXw0M7ENNsYkm2sA7cpZq2zhXBiuWktRvlClTh5
         C6qALVakO/L2T88k88a/w3H+ER2Wyfwolpn39xfdQ5NTuftitsW2r6YYaTSFchjZ4yNu
         IWw0pYpFevyJIHf+L/5UsVe3QrD/jEX8nLcVvg1Fdo5wZejYGlvqX7HXUIQGfpjVk5F0
         uXTg==
X-Gm-Message-State: AOJu0YzFtdclcVDwWliMPHUJYRCns1iZnNt+6/qTve9WHvspigpwdbZS
	t8ibz99ekMxhRhlC85uBnQA1yzbFz0qEcQ==
X-Google-Smtp-Source: AGHT+IFWkisPehW5mgNHv5lMSA+52Wv5yr/IdrWLa96GM4BAoNTZMowZnvHn+ry/MqGB0CvwbmuIrQ==
X-Received: by 2002:a05:651c:226:b0:2cc:e131:784e with SMTP id z6-20020a05651c022600b002cce131784emr812683ljn.40.1704904120454;
        Wed, 10 Jan 2024 08:28:40 -0800 (PST)
Received: from ?IPv6:2804:30c:1668:b300:8fcd:588d:fb77:ed04? ([2804:30c:1668:b300:8fcd:588d:fb77:ed04])
        by smtp.gmail.com with ESMTPSA id a19-20020a1709027d9300b001d3f1ca06b0sm3842413plm.233.2024.01.10.08.28.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jan 2024 08:28:40 -0800 (PST)
Message-ID: <9f15ca09d5d7ea65044795bc3ef5dfa2ad1fb84d.camel@suse.com>
Subject: Re: RFC: another way to make livepatch
From: Marcos Paulo de Souza <mpdesouza@suse.com>
To: pizza <laokz@foxmail.com>, live-patching@vger.kernel.org
Date: Wed, 10 Jan 2024 13:28:31 -0300
In-Reply-To: <tencent_A370A7F1740CD64A13DA74F221EB8B9AC609@qq.com>
References: <tencent_8B36A9FCE07A8CA645DC6F3C3F039C52E407@qq.com>
	 <761e2fc21e72576a4704572b50d9fc5b4a1cb9e1.camel@suse.com>
	 <tencent_A370A7F1740CD64A13DA74F221EB8B9AC609@qq.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.50.1 
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Wed, 2024-01-10 at 22:06 +0800, pizza wrote:
> On Wed, 2024-01-10 at 08:52 -0300, Marcos Paulo de Souza wrote:
> > On Thu, 2023-12-21 at 22:06 +0800, laokz wrote:
> > > Hi,
> > >=20
> > > Is it off-topic talking about livepatch making tool? I tried
> > > another
> > > way and
> > > want to get your expert opinion if there any fatal pitfall.
> >=20
> > I don't think it's out of scope, but what exactly you mean by
> > "another
>=20
> Thanks.
>=20
> > way to make livepatch"? You would like to know about different
> > approaches like source-based livepatch compared to kpatch, or you
> > mean
>=20
> Yes, exactly. Inspired by kpatch, I tried to make livepatch on source
> level
> to avoid difficult binary hacking, just like what we did normal
> module
> development.

This is how we create livepatches at SUSE.

> The main idea is similar to some topics of this mail list,
>=20
> 1. Write livepatch-sample.c stylish source code, put all needed non-
> export/non-include symbols(I call them KLPSYMs) declarations in file.
> 2. Generate KLPSYMs position information through kallsyms etc.
> 3. `KBUILD_MODPOST_WARN=3D1 make` to build a "partial linked" .ko.
> 4. Use a klp-convert like tool to transform the KLPSYMs.

For now we are using kallsyms to get the address of the symbols, but it
will be changed soon due to IBT. The plan here is to also use klp-
convert.

>=20
> For simple patch, hand-write source might be easy though a little
> time
> consuming. I used libclang to auto abbreviate livepatch source[1].
>=20
> The main obstacle, IMO, is "how to determine non-included local
> symbols",
> because they might be inlined, optimized out, duplicate names,
> mangled
> names, and because kallsyms, vmlinux .symtab less some verbose
> information.
> In my toy, I used DWARF along with kallsyms to try to verify all of
> them.=C2=A0
>=20

That's is the tricky part, indeed.

> But now I realized that DWARF might be the fatal pitfall. That's a
> pity. I
> still get hope that's not too bad:)

Interesting. I didn't checked your code, but I can explain how we are
doing things now, and how we plan to do in the future.

Currently we are using klp-ccp[3] to extract the functions for us. The
tool also requires the ELF object that we are patching, plus Symvers
file and the ipa-clones generated when the kernel was compiled. This
way we can detect the symbols that are public (exported by vmlinux),
public from modules (exported by other modules), and private (exported
by the patched module).

For the symbols from vmlinux, we depend on them and call them directly.
For symbols from modules and private symbols, we use kallsyms to get
their address in order to call them.

For optimized symbols, we usually check the callers of the symbol
manually.

We also use a tool called klp-build (we plan to open source it later
this year) to detect duplicated symbols, check if the same symbol is
available and not optimized in different architectures (since we create
livepatches for three different architectures), and to check later if
the code generated/patches doesn't rely on symbols from other modules.

What we are doing right now is a new tool that uses LLVM/libclang to
extract the functions. The new tool also relies on the same
dependencies: module to be patched (to read the symbol table), Symvers
and ipa-clones. The main advantage of it is to rely on LLVM's AST. We
also plan to release this tool later this year. Another interesting
aspect of the new tool is that our userspace livepatching team was who
created the tool, and are using it to create their livepatches. Kernel
supported was added to it afterwards.

We plan to advertise both tools in this ML when they are released,
since we use both to create LPs today (klp-build is used currently with
klp-ccp already, but supported for the new tool is already done, but
not production ready).

Stay tuned :)

>=20
> [1] https://gitee.com/laokz/klpmake
> [2] mirror: https://github.com/laokz/klpmake
[3]: https://github.com/SUSE/klp-ccp
>=20
> > something different?
> >=20
> > Thanks!
> >=20
> > >=20
> > > Thanks.
> > >=20
> > > laokz
> > >=20
> > >=20
> >=20
> >=20
>=20


