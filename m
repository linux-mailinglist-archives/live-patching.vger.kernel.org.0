Return-Path: <live-patching+bounces-1621-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 26A93B2DBDA
	for <lists+live-patching@lfdr.de>; Wed, 20 Aug 2025 13:57:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C8B871C202CC
	for <lists+live-patching@lfdr.de>; Wed, 20 Aug 2025 11:57:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD98C2E5D39;
	Wed, 20 Aug 2025 11:57:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="MPDCSZYG"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5AAA2E3AE2
	for <live-patching@vger.kernel.org>; Wed, 20 Aug 2025 11:57:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755691022; cv=none; b=JJC6znPPbE7Z69lSlb2k0atrOaoQ15/4OKXkz9byaaMnIXc1g0eMPFKagW8q1qKdighQLaZLPm9i7j70k6lhMZ7qFDPdUaoJiU2ZLSHaUliUB/87OpmSiQrUwfF8tlg48sBSnMPMjngxmUERhj5+6P8HNV/lE7XqOIN5NTSwUo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755691022; c=relaxed/simple;
	bh=cYaIwa7OKDucApKeRVWCFfec6pzGvS4Cc/Uc55pPyp0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Kze11ca+u3GRZOrAK+4zD2eHBWs7Ug2YtRHbHg0VERAwfqROOuPy+jaUzpVavMsBHfci8Cg78vgR9r7KCX6Q7zJKpI0F2fX2Yf/Pg8EMCfBO1uXOguDFwoa0UZRYtNFbpANXdQnBPBtNSfWNkUS4TOSl0U6hQ4u1Wl/VfB7c0AY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=MPDCSZYG; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-afcb78d5e74so1099797166b.1
        for <live-patching@vger.kernel.org>; Wed, 20 Aug 2025 04:57:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1755691019; x=1756295819; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=moCsdLjCmUX6PvbdLzVPGIybOfeYotWGYwXLJgkQHp4=;
        b=MPDCSZYGKuKjPbnTkoV2UzJdGYHBV/gjr5NN+Hh2NJeWhxnSVRMER+ZnJILmq4cv5s
         YzZxzb5l4RNEZ+BBKjMIEzSlmkLcjMk3NHIbentsmMGy6Sh2NycfCwqD+CLIOgrJRVs6
         NZWYZg6AwgJWuEcZ3BPTbwrYN7cMdofXR1Qeono7tiu9qzHjpgez87aFb785knM3byLv
         XmWgFOes8k3Beoaag1erxCwtR6o1u3aTGtnNpSNSXAUtkhctZyfjENbdkg5mmC5uYENs
         uEQkFnuVI6rxSkgzPlFndpF3kQeaRdcDWodaahdBWd3CR/GZk2tFV6JDR7tlWcPP/VqS
         06Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755691019; x=1756295819;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=moCsdLjCmUX6PvbdLzVPGIybOfeYotWGYwXLJgkQHp4=;
        b=obuive84gbFDG6JNIfcwncm2xgagSVtcsLXjXezOC1d/MZvBYHkhjOJXVWAFLx+aFh
         o2CyaMmDvVsCZTftBLltMTk0U2JWV92gNm1jh9d54tFr+O+2dwwfLK/mOrDX/uIDqrZn
         Nzn+BvdoWrT8r8n0koxVo7j++qwYQ9uC3PtOociuNzSpwtPVI3zX8IYUh9YloEidTnZw
         F/Fl+X9BU+wOUv+8cWPCmJkexv5RvBidfRaESaRo5hhlcyBnFpOyAbGDXAK+UyoxFeMI
         59Cv1yknIqvSMMeL8sC3s9kfSRadQfPF2rYMZE/XrR9F7zlB5bW3wYUjYIQJAUtIIWMS
         lW0A==
X-Forwarded-Encrypted: i=1; AJvYcCW1RN9J3KPnhJ7Y/ofkts5ZFRnQP5otbiMvLyaq6ls20P/i4/RDj4wNoQQi7iiTjLLnHXUrTeFhejW+/8FL@vger.kernel.org
X-Gm-Message-State: AOJu0YxIrOAMt/gFDqnFMW7gMpU7F8+3xjRovcrPW6fhf1DE3Mq0VEiX
	C2xpXR+KjOqPSHyo0Ra0QoYdosTAyYfyMPvNJDRI2L2nvSzjn5WQrQ3Rcl0sb/2bv1o=
X-Gm-Gg: ASbGncteMDRxT1HlSvEozCTqCgzzt7CLHOI7VZM3fA3ypJ+pvsUwI5r/1+Tbd5oHXYj
	N1OhXict11d2gkhtjX99HQJ6M9TbTuxJzOP+LbeGHJ6/spoQ0/X4H8cQexEPxOB+cZxY0IxvvHg
	1zKw78DyMOQorGHo0ClV4QDMUF1P9RXFdGHQ1AoMxCu2/OkpVcNeuf5EWzsaumgNCdk0KlqZsEl
	0RkJDRml10rn8V6Yx+2jtVzjoaHj3Oj9pFlC7Tq2WLk2TJONugct4bq3nb9g1ADBBMVJgL8y9NQ
	nW9ACcs/dxATYghaBq8waoXpv9TGSuxEp/Yrmn0cp25jyCAFbW01lmX9Nf7XCg2WmEpKF5jdxiE
	EOcT1hxV7IFgG5ybl1+wJRr7ZbUyUnfw2w9vZ
X-Google-Smtp-Source: AGHT+IH8jGgP7Yi06FTb3TEFxWNfS8BaL6kBNZrhzOIwS6IMpjYfsgVAKJNdI/w7l343iLu7BzJvvw==
X-Received: by 2002:a17:906:7313:b0:af9:e1f0:cd15 with SMTP id a640c23a62f3a-afdf00a90e5mr214610866b.18.1755691019015;
        Wed, 20 Aug 2025 04:56:59 -0700 (PDT)
Received: from pathway.suse.cz ([176.114.240.130])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-afded2badcdsm167984366b.21.2025.08.20.04.56.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Aug 2025 04:56:58 -0700 (PDT)
Date: Wed, 20 Aug 2025 13:56:56 +0200
From: Petr Mladek <pmladek@suse.com>
To: Ricardo =?iso-8859-1?Q?B=2E_Marli=E8re?= <rbm@suse.com>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>, Jiri Kosina <jikos@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Shuah Khan <shuah@kernel.org>, live-patching@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
	Marcos Paulo de Souza <mpdesouza@suse.com>
Subject: Re: [PATCH] selftests/livepatch: Ignore NO_SUPPORT line in dmesg
Message-ID: <aKW4CApORh7o73nz@pathway.suse.cz>
References: <20250819-selftests-lp_taint_flag-v1-1-a94a62a47683@suse.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250819-selftests-lp_taint_flag-v1-1-a94a62a47683@suse.com>

On Tue 2025-08-19 14:37:01, Ricardo B. Marlière wrote:
> Some systems might disable unloading a livepatch and when running tests on
> them they fail like the following:
> 
> $ ./run_kselftest.sh -c livepatch
>   TAP version 13
>   1..8
>   # selftests: livepatch: test-livepatch.sh
>   # TEST: basic function patching ... not ok
>   #
>   # --- expected
>   # +++ result
>   # @@ -5,6 +5,7 @@ livepatch: 'test_klp_livepatch': starting
>   #  livepatch: 'test_klp_livepatch': completing patching transition
>   #  livepatch: 'test_klp_livepatch': patching complete
>   #  % echo 0 > /sys/kernel/livepatch/test_klp_livepatch/enabled
>   # +livepatch: attempt to disable live patch test_klp_livepatch, setting
>   NO_SUPPORT taint flag
>   #  livepatch: 'test_klp_livepatch': initializing unpatching transition
>   #  livepatch: 'test_klp_livepatch': starting unpatching transition
>   #  livepatch: 'test_klp_livepatch': completing unpatching transition
>   #
>   # ERROR: livepatch kselftest(s) failed

This seems to be a SUSE-specific feature. The upstream kernel does not
even know the NO_SUPPORT taint flag.

This patch is not for upstream. But we should add it into SUSE
kernel sources.

Best Regards,
Petr

