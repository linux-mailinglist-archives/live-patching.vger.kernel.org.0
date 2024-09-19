Return-Path: <live-patching+bounces-665-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B85C97C4FD
	for <lists+live-patching@lfdr.de>; Thu, 19 Sep 2024 09:40:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2BFAF282D81
	for <lists+live-patching@lfdr.de>; Thu, 19 Sep 2024 07:40:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A616E194AFB;
	Thu, 19 Sep 2024 07:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="WH3FNodk"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com [209.85.208.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FF53194AE6
	for <live-patching@vger.kernel.org>; Thu, 19 Sep 2024 07:40:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726731638; cv=none; b=I6xdbBY6EV0bLcTshq2tfO6pKgRtk66PDRxWQAW6tsTF9n5EtxhaB7hX43wPuZQGx1jzN3SU49mcfIml56AqRFMpKW5G8wPB7ZVvMlFR0/XQX1bAQw/bWwXEgjE+MBbT9WjBtXsubbNkFVqqb3yBygHHQMje49aVFJ2wLj9TTyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726731638; c=relaxed/simple;
	bh=pUewmzSQ/chwewLKgMWV8JIc+qjrgyttwnamSC3vfY8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u3odpt0pmbl9ORaMys0jtLVAAYJ2yIqs9zf+Nywkg8YfWFdE8X1qe3kBRBF4UA1GPnj/KJygMejNOanTvh4AnSshUrJ0tsuOT+LrgrYNoPw45gqeje/7xQkoqhAsPxmG+v2MM8ezuzRAwyIxcLotuLwLX87DwBfwj1QaaGFp9Ns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=WH3FNodk; arc=none smtp.client-ip=209.85.208.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-lj1-f181.google.com with SMTP id 38308e7fff4ca-2f74e468baeso5621731fa.2
        for <live-patching@vger.kernel.org>; Thu, 19 Sep 2024 00:40:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1726731632; x=1727336432; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=9KiJyXXa/hDb3EoSXa8lhhJ8iZ2R95tydPsM2Z3Ehcs=;
        b=WH3FNodkqJYTgzBZsElNQPBNa1smb6zQXSdSLYI3Wc05tgFIaSHwtgkPuwSMXHUaHW
         deV6+hw635aQ0MxKj+Vv7Oem38AAvZl7yhGKuFrFU5q9ON0r853474TImoufI+nYAjhd
         Jb/ehh3tpUugZzovrGV6ZB9jJOlvIS36pA0o+y5uYxeUi7lVIgbIznmtAVNDLHjBFjNY
         ZVLOAx9ByBpQ9UbO5XKARoxfCZaJBdoPLmn7Emz8wV9yDyTxlgokHfCVTxDd5aV98gP/
         /+0Krt0I3O3hOsImN3Z1eV0OrwfFJkrOHJTti3f/ddnHWzKDapyIGnQG9qBkkQaMuHRn
         b+0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726731632; x=1727336432;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9KiJyXXa/hDb3EoSXa8lhhJ8iZ2R95tydPsM2Z3Ehcs=;
        b=e2RJH3WZ0KaBXyOuMc9ZtUlkb4SrLRUbzEXfFTM8pWdC4iH64nbpRsrOU1voHttDIf
         oyJpR4oawLyCuS69mzFjB9fuubdds6aXNYECBKXr9CW7GzSnDjZL0D7y0usLxX1y7X4S
         IGLtuEapLn6g9pHe6Tg1kDcF/mqBSC1wHX9Q/slF3gOl8B65jHRr7HXCvhwKeCsu1YZ6
         dQDoqn9sk68TmVFjfRoPOY9iBXfdSf3+WPmUSlS51UAknojRH3zT6k3FY0AGq26DYFeJ
         fhEZRRkIA6mYXhsWh6fNvRT5AAteqQUfaDQiLX9MUn77A1lbTpoJWNrq5XRL9B/o8Zfc
         wMGw==
X-Forwarded-Encrypted: i=1; AJvYcCUmSDePfZ8i+umdiyxo+n+t3ehn+FAeorZ335ZzlVN6ja9YGxaX4BU99VJhfeH3cLb1ki4fU7TtAHWAlRKh@vger.kernel.org
X-Gm-Message-State: AOJu0YxiWIAizMezmMweX+nmmWyfWtoGPQiw4y0RghmNTYN4ZIbrzj+e
	bntKzkBl1d2nmSDOsYTK9ZZLlGEaSgrTc6FggnXFvIiUCBBj65u0TpHDqqfpoJ0=
X-Google-Smtp-Source: AGHT+IG6bQEzkLR42jQfK0C42qpX60THGfI6PrUWv2z7at25FF0uJPzYOogibcVNU6ys7Y69TjTMNw==
X-Received: by 2002:a2e:a544:0:b0:2f6:5df8:bfcb with SMTP id 38308e7fff4ca-2f791b5a8c8mr111755521fa.38.1726731632094;
        Thu, 19 Sep 2024 00:40:32 -0700 (PDT)
Received: from pathway.suse.cz ([176.114.240.50])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2dd6eea097dsm1039720a91.20.2024.09.19.00.40.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Sep 2024 00:40:31 -0700 (PDT)
Date: Thu, 19 Sep 2024 09:40:22 +0200
From: Petr Mladek <pmladek@suse.com>
To: Michael Vetter <mvetter@suse.com>
Cc: linux-kselftest@vger.kernel.org, live-patching@vger.kernel.org
Subject: Re: [PATCH v2] selftests: livepatch: test livepatching a kprobed
 function
Message-ID: <ZuvVZneTT7SY76wP@pathway.suse.cz>
References: <20240917135059.73346-1-mvetter@suse.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240917135059.73346-1-mvetter@suse.com>

On Tue 2024-09-17 15:50:53, Michael Vetter wrote:
> The test proves that a function that is being kprobed and uses a
> post_handler cannot be livepatched.
> 
> Only one ftrace_ops with FTRACE_OPS_FL_IPMODIFY set may be registered
> to any given function at a time.
> 
> --- /dev/null
> +++ b/tools/testing/selftests/livepatch/test-kprobe.sh
> @@ -0,0 +1,65 @@
> +#!/bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (C) 2024 SUSE
> +# Author: Michael Vetter <mvetter@suse.com>
> +
> +. $(dirname $0)/functions.sh
> +
> +MOD_LIVEPATCH=test_klp_livepatch
> +MOD_KPROBE=test_klp_kprobe
> +
> +setup_config
> +
> +# Kprobe a function and verify that we can't livepatch that same function
> +# when it uses a post_handler since only one IPMODIFY maybe be registered
> +# to any given function at a time.
> +
> +start_test "livepatch interaction with kprobed function with post_handler"
> +
> +STATE=$(cat /sys/kernel/debug/kprobes/enabled)
> +echo 1 > /sys/kernel/debug/kprobes/enabled
> +
> +load_mod $MOD_KPROBE has_post_handler=true
> +load_failing_mod $MOD_LIVEPATCH
> +unload_mod $MOD_KPROBE
[...]
> +echo $STATE > /sys/kernel/debug/kprobes/enabled

The original state won't get restored when the test fails.

A better solution would be to integrate this into setup_config()
and cleanup() in /tools/testing/selftests/livepatch/functions.sh

Also it would be great to avoid hard-coding /sys/kernel/debug.
See KLP_SYSFS_DIR="/sys/kernel/livepatch" in
/tools/testing/selftests/livepatch/functions.sh

I would replace it with:

KERNEL_SYSFS_DIR="/sys/kernel"
KLP_SYSFS_DIR="$KERNEL_SYSFS_DIR/livepatch"
DEBUG_SYSFS_DIR="$KERNEL_SYSFS_DIR/debug"
KPROBES_SYSFS_DIR="$DEBUG_SYSFS_DIR/kprobes"

It would actually look better with switched ordering:

SYSFS_KERNEL_DIR="/sys/kernel"
SYSFS_KLP_DIR="$SYSFS_KERNEL_DIR/livepatch"
SYSFS_DEBUG_DIR="$SYSFS_KERNEL_DIR/debug"
SYSFS_KPROBES_DIR="$SYSFS_DEBUG_DIR/kprobes"

But this would require renaming KLP_SYSFS_DIR everywhere in
a separate (prerequisite) patch. It would be nice but
I do not want to force you to do it ;-)

> --- a/tools/testing/selftests/livepatch/test_modules/Makefile
> +++ b/tools/testing/selftests/livepatch/test_modules/Makefile
> @@ -11,7 +11,8 @@ obj-m += test_klp_atomic_replace.o \
>  	test_klp_state2.o \
>  	test_klp_state3.o \
>  	test_klp_shadow_vars.o \
> -	test_klp_syscall.o
> +	test_klp_syscall.o \
> +	test_klp_kprobe.o

Nit: Please, put it in alphabetical order. It is not a big deal.
     The ordering helps searching. The list already is almost sorted.
     And the patch needs to be updated anyway.

>  # Ensure that KDIR exists, otherwise skip the compilation
>  modules:
> diff --git a/tools/testing/selftests/livepatch/test_modules/test_klp_kprobe.c b/tools/testing/selftests/livepatch/test_modules/test_klp_kprobe.c
> new file mode 100644
> index 000000000000..49b579ea1054
> --- /dev/null
> +++ b/tools/testing/selftests/livepatch/test_modules/test_klp_kprobe.c
> @@ -0,0 +1,38 @@
[...]
> +module_init(kprobe_init)
> +module_exit(kprobe_exit)
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Michael Vetter <mvetter@suse.com>");
> +MODULE_DESCRIPTION("Livepatch test: livepatch kprobed function");

Nit: The module adds a kprobe. I would invert the logic:

MODULE_DESCRIPTION("Livepatch test: kprobe livepatched function");

Best Regards,
Petr

