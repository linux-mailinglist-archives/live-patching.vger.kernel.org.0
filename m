Return-Path: <live-patching+bounces-429-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id CF8109460C3
	for <lists+live-patching@lfdr.de>; Fri,  2 Aug 2024 17:45:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 49A44B25067
	for <lists+live-patching@lfdr.de>; Fri,  2 Aug 2024 15:45:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A620136350;
	Fri,  2 Aug 2024 15:45:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Di+TKaP2"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B458D13633D
	for <live-patching@vger.kernel.org>; Fri,  2 Aug 2024 15:45:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722613517; cv=none; b=jbH2hBRrTAmkF7DHT4+23u/34vpNPR5YwXUjWSBR7BRZCMNUIiLiWIiM7ncIQyAxo9t2H+tOD99il52gK5sSLqEGreaTfZLlE4SgP/Ow3XODcJgn5DndT9F+jkTdv+X1AgeboAkqLHJ26jLJyhuyWTqKcJBaHWtgEmbXCtrhVW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722613517; c=relaxed/simple;
	bh=vfeB93M/fkKcif1ZBMwCAiqTjJhujRl0H2Mr8mI9Ydo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hMdfKweYB3u5h2tC3dguRWdbsaI5DeVkqm9q66Cud9TQQlk+arFVkX+jZ8vC5lJU3Fgh5NzLsvft0l/rk8m0y9+uCacVdGlNRgXp2VN7ErIkwcmTmoNG+JWPb/5QvUxKl2EzpGoqJ5whbkm0Z+wCzErLrDsoE7kZYwlSiW8qo3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Di+TKaP2; arc=none smtp.client-ip=209.85.167.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-52efbb55d24so13049372e87.1
        for <live-patching@vger.kernel.org>; Fri, 02 Aug 2024 08:45:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1722613514; x=1723218314; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=g344hXeVyHKh0h8Ndl7PidMPNboqwCMD43esLIm9SlI=;
        b=Di+TKaP2InY16OJIfI4jSxahjUCfKt8Il0uV0pneeAngKIzAGoLMZX5Hch/xinnOEn
         IY/dHcX5QrHCVQ82AS4Ovd4AWhq/WaVoFXsOcIUIUCH5UpGvI9A3kr+2CxL97NsauzRl
         yNJUwRFmwEI09HzYNv2UUZGGVdAFoRed7I8xJJW7QS3RQF4iuVR19n8YBcaK08F1HPkE
         6IgqKKR+IpMPrBba/gsPJPJ3JD3FI1X+851+rk5+K+FF93aNszhd2vda1iR/uAPguJ/y
         k87Oiw4W0rwxemTE8FLJMr5DbfD+DG1EmMdI3raKU4ibfQUfZ3eto32yRRpsvP28lcea
         QCgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722613514; x=1723218314;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=g344hXeVyHKh0h8Ndl7PidMPNboqwCMD43esLIm9SlI=;
        b=qP2zR57BlWrXB3UUK5UnapAB8DFMHfRYrOApVW63+eRUvHMhoV1NYIo4CzFX4iPFj7
         SJZFRfZ3rr8dZm310hqTudUhsvSOWMW3bVLu2m4MHBMqHQN8tYrJ6oVkUVsuIWCGKhsT
         RfDn6lkuCn1e9G+MCtxoV48H6/IwuAUhRWYRY+wgOI6LntQUoqMoqwjSTIfQLddxpfqi
         Ld081I3Ibd4BHw5bAP4JePOMujUZlPvBmNHNJTTnZ9l/k2dH8HNNwZqEcD40HORY/X6y
         KQLmksQMVFgl7mupWAGUjRK+vKT7TGJRGSoEXxkT03s+P6yi6yCEFcyP5b6TCFZ2cTqS
         hGNQ==
X-Forwarded-Encrypted: i=1; AJvYcCUn2VgNcZZm2/2Q5UUmzMi/3fA/1NPxvaGm2Xt8XJRSOJ/1jyRb3WdxYBFYbW30Hp6lRqi2ociPHlh8pH8276yxjI6tr8nYbSKGPGXlpA==
X-Gm-Message-State: AOJu0Yx46DGwhgXOXYLA1uMhKG1ltMekjflEWLzRyN3t3t8mtvWmV5dI
	/BGSFGzOTxW/xvXSYb2Sgk3x/qNjXxEDgmmKa7KfkA6XFXCQ42osUd5NcPjv8Qg=
X-Google-Smtp-Source: AGHT+IF92mf30V2shYY8+BYVIGZyQAWoW9P1sG2SndbCMSqUU1iSOZo/jY/ZBXunuWJPJ+uhL/fIPQ==
X-Received: by 2002:a05:6512:1593:b0:52d:582e:4111 with SMTP id 2adb3069b0e04-530bb3810c5mr3672332e87.18.1722613513633;
        Fri, 02 Aug 2024 08:45:13 -0700 (PDT)
Received: from pathway.suse.cz ([176.114.240.50])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a7dc9c0b761sm112174766b.55.2024.08.02.08.45.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Aug 2024 08:45:13 -0700 (PDT)
Date: Fri, 2 Aug 2024 17:45:11 +0200
From: Petr Mladek <pmladek@suse.com>
To: Song Liu <songliubraving@meta.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>, Song Liu <song@kernel.org>,
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
	Sami Tolvanen <samitolvanen@google.com>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 2/3] kallsyms: Add APIs to match symbol without
 .llmv.<hash> suffix.
Message-ID: <Zqz_BwG1fcQaUsoY@pathway.suse.cz>
References: <20240730005433.3559731-1-song@kernel.org>
 <20240730005433.3559731-3-song@kernel.org>
 <20240730220304.558355ff215d0ee74b56a04b@kernel.org>
 <5E9D7211-5902-47D3-9F4D-8DEFD8365B57@fb.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5E9D7211-5902-47D3-9F4D-8DEFD8365B57@fb.com>

On Wed 2024-07-31 01:00:34, Song Liu wrote:
> Hi Masami, 
> 
> > On Jul 30, 2024, at 6:03 AM, Masami Hiramatsu <mhiramat@kernel.org> wrote:
> > 
> > On Mon, 29 Jul 2024 17:54:32 -0700
> > Song Liu <song@kernel.org> wrote:
> > 
> >> With CONFIG_LTO_CLANG=y, the compiler may add suffix to function names
> >> to avoid duplication. This causes confusion with users of kallsyms.
> >> On one hand, users like livepatch are required to match the symbols
> >> exactly. On the other hand, users like kprobe would like to match to
> >> original function names.
> >> 
> >> Solve this by splitting kallsyms APIs. Specifically, existing APIs now
> >> should match the symbols exactly. Add two APIs that matches the full
> >> symbol, or only the part without .llvm.suffix. Specifically, the following
> >> two APIs are added:
> >> 
> >> 1. kallsyms_lookup_name_or_prefix()
> >> 2. kallsyms_on_each_match_symbol_or_prefix()
> > 
> > Since this API only removes the suffix, "match prefix" is a bit confusing.
> > (this sounds like matching "foo" with "foo" and "foo_bar", but in reality,
> > it only matches "foo" and "foo.llvm.*")
> > What about the name below?
> > 
> > kallsyms_lookup_name_without_suffix()
> > kallsyms_on_each_match_symbol_without_suffix()

This looks like the best variant to me. A reasonable compromise.

> >> These APIs will be used by kprobe.
> > 
> > No other user need this?
> 
> AFACIT, kprobe is the only use case here. Sami, please correct 
> me if I missed any users. 
> 
> 
> More thoughts on this: 
> 
> I actually hope we don't need these two new APIs, as they are 
> confusing. Modern compilers can do many things to the code 
> (inlining, etc.). So when we are tracing a function, we are not 
> really tracing "function in the source code". Instead, we are 
> tracing "function in the binary". If a function is inlined, it 
> will not show up in the binary. If a function is _partially_ 
> inlined (inlined by some callers, but not by others), it will 
> show up in the binary, but we won't be tracing it as it appears
> in the source code. Therefore, tracing functions by their names 
> in the source code only works under certain assumptions. And 
> these assumptions may not hold with modern compilers. Ideally, 
> I think we cannot promise the user can use name "ping_table" to
> trace function "ping_table.llvm.15394922576589127018"
> 
> Does this make sense?

IMHO, it depends on the use case. Let's keep "ping_table/"
as an example. Why people would want to trace this function?
There might be various reasons, for example:

  1. ping_table.llvm.15394922576589127018 appeared in a backtrace

  2. ping_table.llvm.15394922576589127018 appeared in a histogram

  3. ping_table looks interesting when reading code sources

  4. ping_table need to be monitored on all systems because
     of security/performance.

The full name "ping_table.llvm.15394922576589127018" is perfectly
fine in the 1st and 2nd scenario. People knew this name already
before they start thinking about tracing.

The short name is more practical in 3rd and 4th scenario. Especially,
when there is only one static symbol with this short name. Otherwise,
the user would need an extra step to find the full name.

The full name is even more problematic for system monitors. These
applications might need to probe particular symbols. They might
have hard times when the symbol is:

    <symbol_name_from_sources>.<random_suffix_generated_by_compiler>

They will have to deal with it. But it means that every such tool
would need an extra (non-trivial) code for this. Every tool would
try its own approach => a lot of problems.

IMHO, the two APIs could make the life easier.

Well, even kprobe might need two APIs to allow probing by
full name or without the suffix.

Best Regards,
Petr

