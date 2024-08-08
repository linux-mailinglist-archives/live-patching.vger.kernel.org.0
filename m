Return-Path: <live-patching+bounces-467-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D49CC94BA40
	for <lists+live-patching@lfdr.de>; Thu,  8 Aug 2024 11:59:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 30902B21449
	for <lists+live-patching@lfdr.de>; Thu,  8 Aug 2024 09:59:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C61FC1891D6;
	Thu,  8 Aug 2024 09:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="WVDId8eX"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4C20145B25
	for <live-patching@vger.kernel.org>; Thu,  8 Aug 2024 09:59:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723111146; cv=none; b=se5iKx712RKXAPL3QRFIamx8MCVOk5lhInMPkXL7uqHzp7hOUo01+ez8h/vneiRsbyEv7HEgOEPsZ6b0GLuNcAC0Yn77EUFRtrbryv+fvfoMTfHvgurT5JZf25RW4NTe5b21jC2LAplaOVlJaL8xWjzXzd6Mz543jmdM0oqdO58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723111146; c=relaxed/simple;
	bh=pGmVQpP4pPuD5fcNHJ1UuHYXYgUIFk/XFz533Uf3FT4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aNz29CILE7Tbr8O+v1jyQBGA5dt7wWAuWD5Jt+DdH7K4dZ5dp3H8/6+oP+RcDSSTZHd5ArtX5CXwR4tk27ObjyiCRhA986F1ix/Bn1k5ofpdZ9o2hByV3BTgbdznop2ri796Lln2lJdDsjnWOI33TAyJ7iSIpl0J3ZhVCHCSsKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=WVDId8eX; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-a7a94478a4eso296824666b.1
        for <live-patching@vger.kernel.org>; Thu, 08 Aug 2024 02:59:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1723111143; x=1723715943; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Fcx2EwOfwUSAtVSfh1fPy+at8W7SLWNzydZ39p3XCNI=;
        b=WVDId8eX6lPO9kdf2jVLsCEg0J4NMOgEYR9iAzg1qVy+gizxXXWjV/yj4MezEeZq0+
         +55Q9exR22Yq0QNwWRYLg88iL+N8ns8hxOorkY2P7fxICMcL1EtCMQHYxxUThjbDkIEk
         zLkdURoilTq54bAQT3C/RM4xPs0Y5G9Q/ND2+hcp/GL8x51+I77o58GH+R26aPDITOPd
         It+GZb50gRZLvH+COLoIsGQbFxw79djhaguhWxN6wCTdPvfpW41fkNJwYl48MoPjvjqW
         DJO8vxLDpwRKchKzK2umgJSXQXrxNoJw8b4sJlmOCpEyzdi6VTadSQYm6rlr9ANbIOEj
         gT+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723111143; x=1723715943;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Fcx2EwOfwUSAtVSfh1fPy+at8W7SLWNzydZ39p3XCNI=;
        b=t7P/K64bySYMyautKxSt6GQmuCDn+YQU0Xye3p8eh/WyTQsC08eMGBY8xA5TcfcgzR
         f4RKAatZxEPomEVfTeOIOx5R2HlSmTf+WZIu/nnN97e9imk64ESA4pxSKAw6ifspzTfl
         WUwblu4axU/v50bqz5ZvebEjjBA4173GVB7W7WGqtLZsYTyY7zZAc7TTLYZZOyaKyZXt
         6waL24YZo8gHo8buhJYzXe5+E8PITkUqfDRgqAqQvlZw9LLYRpwqDWaBKdWiy9W651Bv
         Jf2kJxIOZG+vqfYbNjKmjULZhmkJJxkLBrmWTrm3uwm7IBoJfQWCrI1B00CUHYdDjrr4
         l4pg==
X-Forwarded-Encrypted: i=1; AJvYcCV/ATyFkyXiYuRWIkglb8t7V4EFMGZt8nIOW56FyxGy3mylO/7cpt1p8FvK4BtAwrb2Mk3S8KBJn6vvA96k4NNpUFj9F3ZMctnXb8nlIQ==
X-Gm-Message-State: AOJu0YzVJzbRodZwJMBIi0MXDcpyXQghxNJlJ7caB6CVWOYSspkxswcD
	MSX+sn42pfZDb8RYwR0TP7sl2KFHuR9B8jTthnmfZBVztySyvc428H8bkKixYvI=
X-Google-Smtp-Source: AGHT+IFL8ep1gZsn49dY0KctCRlF+ZQwvI1yNn8Wrf1nzNSBPa/BG9Ul0XeVVDKTQY+z/+grscb8pg==
X-Received: by 2002:a17:907:9814:b0:a7a:afe8:1013 with SMTP id a640c23a62f3a-a8091ed3d11mr121335066b.1.1723111143072;
        Thu, 08 Aug 2024 02:59:03 -0700 (PDT)
Received: from pathway.suse.cz ([176.114.240.50])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a7dc9bc3be2sm729036866b.38.2024.08.08.02.59.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Aug 2024 02:59:02 -0700 (PDT)
Date: Thu, 8 Aug 2024 11:59:00 +0200
From: Petr Mladek <pmladek@suse.com>
To: Song Liu <songliubraving@meta.com>
Cc: Sami Tolvanen <samitolvanen@google.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>, Song Liu <song@kernel.org>,
	"live-patching@vger.kernel.org" <live-patching@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	"linux-trace-kernel@vger.kernel.org" <linux-trace-kernel@vger.kernel.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Jiri Kosina <jikos@kernel.org>, Miroslav Benes <mbenes@suse.cz>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Nathan Chancellor <nathan@kernel.org>,
	"morbo@google.com" <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Leizhen <thunder.leizhen@huawei.com>,
	"kees@kernel.org" <kees@kernel.org>,
	Kernel Team <kernel-team@meta.com>,
	Matthew Maurer <mmaurer@google.com>,
	"Alessandro Carminati (Red Hat)" <alessandro.carminati@gmail.com>
Subject: Re: [PATCH v2 3/3] tracing/kprobes: Use APIs that matches symbols
 without .XXX suffix
Message-ID: <ZrSW5KgFMjlB1Rn2@pathway.suse.cz>
References: <20240806144426.00ed349f@gandalf.local.home>
 <B53E6C7F-7FC4-4B4B-9F06-8D7F37B8E0EB@fb.com>
 <20240806160049.617500de@gandalf.local.home>
 <20240806160149.48606a0b@gandalf.local.home>
 <6F6AC75C-89F9-45C3-98FF-07AD73C38078@fb.com>
 <20240807090146.88b38c2fbd1cd8db683be22c@kernel.org>
 <BEEE3F89-717B-44A4-8571-68DA69408DA4@fb.com>
 <20240807190809.cd316e7f813400a209aae72a@kernel.org>
 <CABCJKucdMS1hkWjHWty8JyACjZy2R9juusABcbsMYzNej=pB2Q@mail.gmail.com>
 <09ED7762-A464-45FF-9062-9560C59F304E@fb.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <09ED7762-A464-45FF-9062-9560C59F304E@fb.com>

On Wed 2024-08-07 20:48:48, Song Liu wrote:
> 
> 
> > On Aug 7, 2024, at 8:33 AM, Sami Tolvanen <samitolvanen@google.com> wrote:
> > 
> > Hi,
> > 
> > On Wed, Aug 7, 2024 at 3:08 AM Masami Hiramatsu <mhiramat@kernel.org> wrote:
> >> 
> >> On Wed, 7 Aug 2024 00:19:20 +0000
> >> Song Liu <songliubraving@meta.com> wrote:
> >> 
> >>> Do you mean we do not want patch 3/3, but would like to keep 1/3 and part
> >>> of 2/3 (remove the _without_suffix APIs)? If this is the case, we are
> >>> undoing the change by Sami in [1], and thus may break some tracing tools.
> >> 
> >> What tracing tools may be broke and why?
> > 
> > This was a few years ago when we were first adding LTO support, but
> > the unexpected suffixes in tracing output broke systrace in Android,
> > presumably because the tools expected to find specific function names
> > without suffixes. I'm not sure if systrace would still be a problem
> > today, but other tools might still make assumptions about the function
> > name format. At the time, we decided to filter out the suffixes in all
> > user space visible output to avoid these issues.
> > 
> >> For this suffix problem, I would like to add another patch to allow probing on
> >> suffixed symbols. (It seems suffixed symbols are not available at this point)
> >> 
> >> The problem is that the suffixed symbols maybe a "part" of the original function,
> >> thus user has to carefully use it.
> >> 
> >>> 
> >>> Sami, could you please share your thoughts on this?
> >> 
> >> Sami, I would like to know what problem you have on kprobes.
> > 
> > The reports we received back then were about registering kprobes for
> > static functions, which obviously failed if the compiler added a
> > suffix to the function name. This was more of a problem with ThinLTO
> > and Clang CFI at the time because the compiler used to rename _all_
> > static functions, but one can obviously run into the same issue with
> > just LTO.
> 
> I think newer LLVM/clang no longer add suffixes to all static functions
> with LTO and CFI. So this may not be a real issue any more?
> 
> If we still need to allow tracing without suffix, I think the approach
> in this patch set is correct (sort syms based on full name,

Yes, we should allow to find the symbols via the full name, definitely.

> remove suffixes in special APIs during lookup).

Just an idea. Alternative solution would be to make make an alias
without the suffix when there is only one symbol with the same
name.

It would be complementary with the patch adding aliases for symbols
with the same name, see
https://lore.kernel.org/r/20231204214635.2916691-1-alessandro.carminati@gmail.com

I would allow to find the symbols with and without the suffix using
a single API.

Best Regards,
Petr

