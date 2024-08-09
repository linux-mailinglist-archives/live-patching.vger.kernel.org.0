Return-Path: <live-patching+bounces-476-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9293C94D3C5
	for <lists+live-patching@lfdr.de>; Fri,  9 Aug 2024 17:40:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 22D551F214EB
	for <lists+live-patching@lfdr.de>; Fri,  9 Aug 2024 15:40:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69D26198A19;
	Fri,  9 Aug 2024 15:40:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="CdMgFVBZ"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AB49194C62
	for <live-patching@vger.kernel.org>; Fri,  9 Aug 2024 15:40:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723218009; cv=none; b=uq7ITe6HRkoa07GVVVX6XrSfYjkZzi+INGwQDd+6fwfv3wsFypBAM0UZ9zaZmTO5jSho9T0yALpFG5PVPea/iJyaTDLjG/pxEVlB2ZtGJdiJNHHgohW/iaM5F8DkPB5e5ioLwoks+xsb0DeBKWwfRJh/t0dLUk+nC2TNzpIyJ4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723218009; c=relaxed/simple;
	bh=7uxpbX0dUiV2nAtAAnEFPVZf9an/qeChOgroY1rCZn8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XPVEIgA5N+4VCBvGr0EMcf6hCbuhSwHzLyLMWfuSJ6OOeQDnZomquOm5oYZMuSoziJWApZ0jGi1eSkM55fWOT7vFtGKO+lx67QC7HJAXQXtfmHuHKUhzXI7sdzhasw4OvT5ZyFjdiTwHeHgCCH7ibYmF5OiPQj51ZQU2jn3Nh5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=CdMgFVBZ; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-a7a9cf7d3f3so264883766b.1
        for <live-patching@vger.kernel.org>; Fri, 09 Aug 2024 08:40:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1723218005; x=1723822805; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=g9/gdXLxSnsU9nxoiw00oEcO7EcPaiVsBgSH221d6bo=;
        b=CdMgFVBZj9uRB6Hm+ZK6IAvIQd51ws0M+duKz3z1OCIT7NvOdmMEZ9uqDmXTdv2oG3
         BKH43dITcFZhdqPo7pOW9EMNXM8VroSJGCzEBQZe3+H3Cu1Eni1rbUiEPud0pSIwkVS0
         l5h35eSSleDacrFJQQQoB1UQmwSTA0EcLFzEs1kEeM+iH2/LrFdnYeX9ihwLW6EOPzF9
         mbmsu1Hcda4pOPVI6EQpCR/GaGIc09oM3cz37duFUaOzMcYPbxgXuvXnvHE1yJybProF
         yKZrOSd8XpyPZtIRtdS7V2G5xUhlvLNPGSndqkdxAjzaYQ182jpGhf8yWGMazstZ71uO
         g/fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723218005; x=1723822805;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=g9/gdXLxSnsU9nxoiw00oEcO7EcPaiVsBgSH221d6bo=;
        b=dFRwS6Fz/EbWcBzJa0xrnYOu6x08ahQpWe1of8WkVm67fC4ysRHfWtGNJFFtnQkgB/
         2KkjPIslL/2Lfb3+vJgpLCoOMfMtiB7uxbmRJxu8pcDo0z3zawI81jj/2qK/8GEa5nZ2
         L3qrr6V5EoQW+Mz0tPz3P469O75FTaLPPn08TTDvdQlQ9Ayw+WHyXWYW9ZsRIuxq+G3t
         vnq7RetrIl79TnIy6y+zQm5n16xWBFLWnXxeMkIISNArPlRN8YU/CD33TAMlW+JYsawp
         R8bAWB4zs4lsCb6Vp2rTg+BF3xFIHybuPuvSUvYHnaJvin9YXxLtMoDuZ3GoXmdig0pA
         j4Iw==
X-Forwarded-Encrypted: i=1; AJvYcCVtl/NPgu3LuMI+9Uin5mqY6wvnS5b8+12l51hue40tdBKFnngBv79ZW6+SUS3wuI0gCnruNW7jpm8uj3Hlamid4PEVPWd94wXkHXMJug==
X-Gm-Message-State: AOJu0YzDPe4oA/2rIRIZXdCf0vrNs8efb9q67dijOeowCankKq15pIdM
	vM5TCxXvJBYaK3P3cyimaY8T2QppzAhBx0v2b6eNuicQbJML7w+YbjJ/JmnPX4k=
X-Google-Smtp-Source: AGHT+IGaMJDQMYJCSNSGSCt/WttKifUKYpng5iXyE2ihkAwEcQvtfaW+DwlSQS3puMV/UUa3yUyaPg==
X-Received: by 2002:a17:907:e6a4:b0:a7a:929f:c0cb with SMTP id a640c23a62f3a-a80aa5eb16amr149281466b.38.1723218005223;
        Fri, 09 Aug 2024 08:40:05 -0700 (PDT)
Received: from pathway.suse.cz ([176.114.240.50])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a7dc9c12ad3sm851185966b.88.2024.08.09.08.40.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Aug 2024 08:40:04 -0700 (PDT)
Date: Fri, 9 Aug 2024 17:40:02 +0200
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
Message-ID: <ZrY4UhJpsFP_vuds@pathway.suse.cz>
References: <20240806160049.617500de@gandalf.local.home>
 <20240806160149.48606a0b@gandalf.local.home>
 <6F6AC75C-89F9-45C3-98FF-07AD73C38078@fb.com>
 <20240807090146.88b38c2fbd1cd8db683be22c@kernel.org>
 <BEEE3F89-717B-44A4-8571-68DA69408DA4@fb.com>
 <20240807190809.cd316e7f813400a209aae72a@kernel.org>
 <CABCJKucdMS1hkWjHWty8JyACjZy2R9juusABcbsMYzNej=pB2Q@mail.gmail.com>
 <09ED7762-A464-45FF-9062-9560C59F304E@fb.com>
 <ZrSW5KgFMjlB1Rn2@pathway.suse.cz>
 <A3701B71-D95F-4E99-A32D-C1604575D40F@fb.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <A3701B71-D95F-4E99-A32D-C1604575D40F@fb.com>

On Thu 2024-08-08 15:20:26, Song Liu wrote:
> 
> 
> > On Aug 8, 2024, at 2:59 AM, Petr Mladek <pmladek@suse.com> wrote:
> > 
> > On Wed 2024-08-07 20:48:48, Song Liu wrote:
> >> 
> >> 
> >>> On Aug 7, 2024, at 8:33 AM, Sami Tolvanen <samitolvanen@google.com> wrote:
> >>> 
> >>> Hi,
> >>> 
> >>> On Wed, Aug 7, 2024 at 3:08 AM Masami Hiramatsu <mhiramat@kernel.org> wrote:
> >>>> 
> >>>> On Wed, 7 Aug 2024 00:19:20 +0000
> >>>> Song Liu <songliubraving@meta.com> wrote:
> >>>> 
> >>>>> Do you mean we do not want patch 3/3, but would like to keep 1/3 and part
> >>>>> of 2/3 (remove the _without_suffix APIs)? If this is the case, we are
> >>>>> undoing the change by Sami in [1], and thus may break some tracing tools.
> >>>> 
> >>>> What tracing tools may be broke and why?
> >>> 
> >>> This was a few years ago when we were first adding LTO support, but
> >>> the unexpected suffixes in tracing output broke systrace in Android,
> >>> presumably because the tools expected to find specific function names
> >>> without suffixes. I'm not sure if systrace would still be a problem
> >>> today, but other tools might still make assumptions about the function
> >>> name format. At the time, we decided to filter out the suffixes in all
> >>> user space visible output to avoid these issues.
> >>> 
> >>>> For this suffix problem, I would like to add another patch to allow probing on
> >>>> suffixed symbols. (It seems suffixed symbols are not available at this point)
> >>>> 
> >>>> The problem is that the suffixed symbols maybe a "part" of the original function,
> >>>> thus user has to carefully use it.
> >>>> 
> >>>>> 
> >>>>> Sami, could you please share your thoughts on this?
> >>>> 
> >>>> Sami, I would like to know what problem you have on kprobes.
> >>> 
> >>> The reports we received back then were about registering kprobes for
> >>> static functions, which obviously failed if the compiler added a
> >>> suffix to the function name. This was more of a problem with ThinLTO
> >>> and Clang CFI at the time because the compiler used to rename _all_
> >>> static functions, but one can obviously run into the same issue with
> >>> just LTO.
> >> 
> >> I think newer LLVM/clang no longer add suffixes to all static functions
> >> with LTO and CFI. So this may not be a real issue any more?
> >> 
> >> If we still need to allow tracing without suffix, I think the approach
> >> in this patch set is correct (sort syms based on full name,
> > 
> > Yes, we should allow to find the symbols via the full name, definitely.
> > 
> >> remove suffixes in special APIs during lookup).
> > 
> > Just an idea. Alternative solution would be to make make an alias
> > without the suffix when there is only one symbol with the same
> > name.
> > 
> > It would be complementary with the patch adding aliases for symbols
> > with the same name, see
> > https://lore.kernel.org/r/20231204214635.2916691-1-alessandro.carminati@gmail.com
> 
> I guess v3 plus this work may work well together.  
> 
> > I would allow to find the symbols with and without the suffix using
> > a single API.
> 
> Could you please describe how this API would work? I tried some 
> idea in v1, but it turned out to be quite confusing. So I decided 
> to leave this logic to the users of kallsyms APIs in v2. 

If we create an alias without the suffix but only when there is only
one symbol with such a name then we have, for example:

  klp_complete_transition.lwn.123456
  klp_complete_transition		[alias]

  init_once.lwn.2131221
  init_once.lwn.3443243
  init_once.lwn.4324322
  init_once.lwn.5214121
  init_once.lwn.2153121
  init_once.lwn.4342343

This way, it will be possible to find the static symbol
"klp_complete_transition" without the suffix via the alias.
It will have the alias because it has an unique name.

While "init_once" symbol must always be searched with the suffix
because it is not unique.

It looks like >99% of static symbols have unique name.

Best Regards,
Petr

