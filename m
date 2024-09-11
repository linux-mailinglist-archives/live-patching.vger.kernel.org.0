Return-Path: <live-patching+bounces-648-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id ABAEC9753E2
	for <lists+live-patching@lfdr.de>; Wed, 11 Sep 2024 15:29:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6DD33285949
	for <lists+live-patching@lfdr.de>; Wed, 11 Sep 2024 13:29:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95EBE19E973;
	Wed, 11 Sep 2024 13:27:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="fpCtCKo0"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 739C719CC10
	for <live-patching@vger.kernel.org>; Wed, 11 Sep 2024 13:27:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726061254; cv=none; b=q7MquZJUf1+5vsUIxl9QIKYrN4LIl2s6MpVMJDRGE7JpRVEuYMzbrktN0CR2cUHaNka7G4o3uWeSbuMKn6n5C7gk1mTx2At05W9kBzCsX8PKJKtpjux8YPqHR+0w7EWeCgE8R5nMXQWfqt5Vzmg2cc0nAOSCc1YrAyIL3ulZ2rY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726061254; c=relaxed/simple;
	bh=XYxNeP8foVOxU/usRXQZxtotm9g66tXsYnUJKvkGJxA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ko8aeprg8OJANlJ3jHq3HcUwIgrJ1xAaljeg7hUICHlmy4UuaVk+on3N+fT7eE30Oa4+kTUi9Q6r2iXNiz1vzVW7nJAQ9XsLAASFlMBtPZRrrfAzAlt2NswmsvF1Mx+1NAa7VBFFAcB4VbgwMC5jPjRws+kM6EvHAdtl/9EUbbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=fpCtCKo0; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-a8d6d0fe021so444744866b.1
        for <live-patching@vger.kernel.org>; Wed, 11 Sep 2024 06:27:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1726061250; x=1726666050; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=WVbEz45p/3iQTTK+m24sTBRTlq90xKYlj6mKX8slWBQ=;
        b=fpCtCKo0vJ01q2ar8/L8lmvu0ARdBUVmsEj9g7WwmhBQXxV4Dqju6BA2WcDSAXcG4O
         KuBx2G1K3slW1mtWJlmolFH/FkP2/7UsMtvVUZs+viy13be6oixbCMYx9M1nD3DlGGHy
         cWUYiCZetwSFhWGx+JZ1lbJqRNKHq13i2cY3dl5QTh8NykiMTb2SqKw1nqtIYcsGuGbQ
         wp//pbAm8xyJSmeWyhgB7xZJMsLBHuVBxr00Ar/JoUzZSZ3t7ddBVQ4YiUa2p7aLIq9k
         qMI5SbJ41e4VKgjKl2eep+Ki/19Edn8JOWO20PlfVInLsGNx7dwkJJGzSimVdf7DaMnr
         rxhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726061250; x=1726666050;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WVbEz45p/3iQTTK+m24sTBRTlq90xKYlj6mKX8slWBQ=;
        b=rcDATBpNCE7Xto1Kjl6fIfPgfBcxlZk/1b5GAMzjM1DO4vcyYPeJZ8UQbNwRRWl72x
         38uwJTGSOzdAdOvrjz1lsKTBDIn76Kk8h7vKT3RzV4RnryzRWCVM3dFk1u+q2xFsF2lV
         bAO71EV3RZefAc0viUzFRztsbezyMoGEjTVmc0TS+enxag5BowxVQ2+yLZah3dEMcMy5
         KBu1F7wFdcTDvgFz2yiVqm0TnzHi6Yyy4D61k+pkAO7Sr7x8HYL6EhitUXeWYJ4GGGfo
         HnWmL66Rc0vyh/SUuTAZxoM9AKD8wVXMFrqsRpHTlG7ZjAq+0HmLUmrbAoWj3+nojfXF
         KsFA==
X-Gm-Message-State: AOJu0Yxl/698Z9gXLwbZPu/hr75OUkwouT0KzurWBQDksg/HcelyKkeI
	Vx3VtB71lCPcs7lZRA4FrkwSXQ4Z83LRHGrdEdNrLawlBlowHMf71tsk/3FhZ5A=
X-Google-Smtp-Source: AGHT+IGYfcNuLrawZOMIrYxI2db5ueoD85qMReb1+UGl6v3E4qyn+S7fM6OswiHyrluW3lQ1c3Y7Xg==
X-Received: by 2002:a17:907:3f07:b0:a8d:439d:5c44 with SMTP id a640c23a62f3a-a8ffaa978b6mr384717466b.1.1726061249509;
        Wed, 11 Sep 2024 06:27:29 -0700 (PDT)
Received: from pathway.suse.cz ([176.114.240.50])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a8d25d74e26sm617701866b.225.2024.09.11.06.27.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Sep 2024 06:27:29 -0700 (PDT)
Date: Wed, 11 Sep 2024 15:27:27 +0200
From: Petr Mladek <pmladek@suse.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
	x86@kernel.org, Miroslav Benes <mbenes@suse.cz>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Jiri Kosina <jikos@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Marcos Paulo de Souza <mpdesouza@suse.com>,
	Song Liu <song@kernel.org>
Subject: Re: [RFC 00/31] objtool, livepatch: Livepatch module generation
Message-ID: <ZuGav4txYowDpxqj@pathway.suse.cz>
References: <cover.1725334260.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1725334260.git.jpoimboe@kernel.org>

On Mon 2024-09-02 20:59:43, Josh Poimboeuf wrote:
> Hi,
> 
> Here's a new way to build livepatch modules called klp-build.
> 
> I started working on it when I realized that objtool already does 99% of
> the work needed for detecting function changes.
> 
> This is similar in concept to kpatch-build, but the implementation is
> much cleaner.
> 
> Personally I still have reservations about the "source-based" approach
> (klp-convert and friends), including the fragility and performance
> concerns of -flive-patching.  I would submit that klp-build might be
> considered the "official" way to make livepatch modules.

For me, it is not easy to compare the two approaches because I do not
have any practical experience with binary-diff bases approach.
I believe that it has its catches as well.

Anyway, I do not want to open a fight about the two approaches.
I would like to better understand the approach implemented by this
patchset.

First, I have been able to go it working by the extra fixes suggested
in the replies to Song Liu. And it worked well.

Second, I was surprised that the linking of vmlinux.o took much longer
than usual. It seems to be caused by -ffunction-sections
-fdata-sections compiler flags.

The difference is really huge. It might complicate kernel development.
I have done the following test:

	# finish build
	$> make -j8
	# touch a source file to simulate a change
	$> touch include/linux/livepatch.h
	# measure time need for the incremental build
	$> time make -j8

Without -ffunction-sections -fdata-sections:

	$> time make -j8
	real    0m58.719s
	user    3m25.925s
	sys     0m21.895s

With -ffunction-sections -fdata-sections:

	$> time make -j8
	real    13m28.126s
	user    15m43.944s
	sys     0m29.142s

=> Incremental build slowed down from 1min to 13.5min.

Is this expected?

Are you used to this when developing the kernel or do you use
a workaround?


> The concept is similar to kpatch-build which has been a successful
> out-of-tree project for over a decade.  It takes a source .patch as an
> input, builds kernels before and after, does a binary diff, and copies
> any changed functions into a new object file which is then linked into a
> livepatch module.
> 
> By making use of existing objtool functionality, and taking from lessons
> learned over the last decade of maintaining kpatch-build, the overall
> design is much simpler.  In fact, it's a complete redesign and has been
> written from scratch (no copied code).
> 
> Advantages over kpatch-build:
> 
>   - Much simpler design: ~3k fewer LOC

This brings the question how reliable and feature complete this code
is in compare with kPatch which is used in production.

One obvious area is the support of more architectures. I guess that
this  code supports only x86_64 at the moment. While kPatch supports
x86_64, ppc64, and s390. I wonder how complicated it would be to
support more architectures.

Also I tried to compare how kPatch and this code do the binary diff
and found the following:

  a) It seems that kPatch compares the assembly by "memcmp" while
     klp-build uses checksum. This looks good.


  b) Both tools have hacks for many special sections and details.
     I am not sure objtool handles all cases which are handled
     by kPatch.

     For example, it seems that kPatch ignores changes in line numbers
     generated by some macros, see kpatch_line_macro_change_only().
     I can't find a counter part in objtool.


  c) It seems that kPatch contains quite complicated code to correlate
     symbols.

     For example, it correlates local variables by comparing
     functions which reference them, see
     kpatch_correlate_static_local_variables().

     Or kPatch tries to correlate optimized .cold, and .part
     variants of the code via the parent code, see
     kpatch_detect_child_functions()

     While klp-build seems to correlate symbols just be comparing
     the demangled/stripped names, see correlate_symbols().
     This seems to be quite error prone.

     I actually do not understand how klp-build compares symbols
     with the same demangled/stripped names. I probably missed
     a trick somewhere.


Do not get me wrong. I do not expect that the upstream variant would
be feature complete from the beginning. I just want to get a picture
how far it is. The code will be maintained only when it would have
users. And it would have users only when it would be comparable or
better then kPatch.

Best Regards,
Petr

