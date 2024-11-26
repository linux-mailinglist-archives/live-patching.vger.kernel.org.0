Return-Path: <live-patching+bounces-866-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id EDAB69D9852
	for <lists+live-patching@lfdr.de>; Tue, 26 Nov 2024 14:20:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7CF60B2CA87
	for <lists+live-patching@lfdr.de>; Tue, 26 Nov 2024 13:18:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B12951D5161;
	Tue, 26 Nov 2024 13:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="LjXmzCdv"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64FD31D47A2
	for <live-patching@vger.kernel.org>; Tue, 26 Nov 2024 13:18:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732627118; cv=none; b=J38EZqW2b/kr8/2qWj18VW4L3/woI9XwhfweXj2eNk29lljgZ5c45+isNjhtv0D+3QYGU15gHaMRVItDupBbNlx/Yi3+iRo5jzhonRANS0HnjgIeP3vi3OFvMBVedLD06LelmR3OmRGM1fqrohx8HTXa5zChoRI8HnPM4Nne4VQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732627118; c=relaxed/simple;
	bh=XvOczRYBHnqj6D4ESxktzkTKZPxGuV4JkG6dG5SfdTE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MdrMPvfVwjXo32armaXWI4RsUJ23Sgl5JCuJj8Cnu3f/Lz5DnqwDijFNwEnFbmjMLV6LyriANQWwUlKZ1vYGUCLE2D3tKuar6oD6A+jHuCMSFkhQhlsMrmxGVqJT76kyth27YMKUN3nhUFNLSgAPM4G5wM999MzIvqdGUxP3Pwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=LjXmzCdv; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-434a95095efso141425e9.0
        for <live-patching@vger.kernel.org>; Tue, 26 Nov 2024 05:18:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1732627114; x=1733231914; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=EaXfKxew919ViwJMv5co2YOm9WoJznHpNhie1VQ2zKc=;
        b=LjXmzCdvIScCjXsJrKI7BUlXw/ogvQqZrE7ogbKCfawG7sPVTW/r2yLzkHRjgoFOAl
         Ju+jLwmC9/OZ22gOeC42n+91AOxESV2xd45CXrzGxdwuefih23ZMZJO0ZMqMcy2R3mwA
         0DcC2wGHhm+SScrURizhrfX5bwnrhQd4/Xvl1+pyaVNeKD7pwl87GtVzyFVtPi84jdJC
         JLudHHyA3kcZIdVP0fE1atuifeeTjT0e7i7lpB5fwd7/LL7yGMaFHhz7qRyTnev4cS9p
         /hJWaX3YsNlqD9j0oQTErqM0IbimmTe4jLY2PenWig8HVfUAo63b6En3u7MToe9VC5Eh
         lG1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732627114; x=1733231914;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EaXfKxew919ViwJMv5co2YOm9WoJznHpNhie1VQ2zKc=;
        b=siMhuBh3m63JN14Oh8eexUUkm5EYGuPQIkw5rOzUreWosUmJ9xTShhzkZ9caag6BEg
         b0chwAAvCmNtq0PI6KHVjprhRniGIP9JDvUL8SNVDLUBdLL08CJW0VxE+AZmp+3lP9Mj
         Gjj55Z973kQg6Syn+48jLZlQ9RZ5XYFQG/SIUY9pH6ldOkEJPNo93EyO8rnY6kRYB9Nu
         SiTX3gRxpBX50R3ENWzLXxLz0A2noOrsxpy3Z5VzSY2OODh4x/WAg7D5FmYUajP6Wt6b
         APuLr8e/PsOdywgAYK8grf4NAi5Toa4q9lU14XHLvp2FjkX+DCKcHyoWs37nHXDKCxDX
         7uWA==
X-Forwarded-Encrypted: i=1; AJvYcCX3CtmKCoRpleuDvV7CZ9W+/PKlAVSR5Mbg/vgsnG1+vtYW/g+2r4xy/BuL9SPT0sVRjm5yZS6jz2j8LYtJ@vger.kernel.org
X-Gm-Message-State: AOJu0Yx9/6RQS6AK9bBev74EAh+9RpPfEIIypL2OZRrIm/KOpr2vMYW0
	CMvR7Ydso0iQBzq5boj4waJvFbusW5g2TWD3a3HQu1D1Azk7YNUbSOSENpx00aE=
X-Gm-Gg: ASbGnctSYZlxzoHxwaS373w8t/aZD9jw27SRnb78EIX+mt6L2cK9omKJzyFaGHjEW2d
	LzIgktoh18jPqrbVwLmhdKmhEFPHzhddJ49kbepjy8dAmaYF/z8mtWhVfdLxX8LVU7s9Kv31/KB
	vm3RjcptAh5naDEAr0q+3J1Su7lGO/yiEa9eADlOnbT9yIMjW9euQPtL1qR7Qvq4fd2iNinKpFx
	xVd7dIcEYHRmu3nWGte94OvtQrkdEn84Cd4TyGXk95GtBQlj9A=
X-Google-Smtp-Source: AGHT+IFqrzqPLKiXN8EGHTiOqvtymXHH3HCsdhZtbH4hWUr3e3NQjnGkP9XHsrV6DaHZ2smDfxKoOg==
X-Received: by 2002:a05:600c:8a9:b0:42c:b67b:816b with SMTP id 5b1f17b1804b1-434a4e56629mr27530185e9.1.1732627113846;
        Tue, 26 Nov 2024 05:18:33 -0800 (PST)
Received: from pathway.suse.cz ([176.114.240.50])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4349e80e51esm82131645e9.33.2024.11.26.05.18.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Nov 2024 05:18:33 -0800 (PST)
Date: Tue, 26 Nov 2024 14:18:30 +0100
From: Petr Mladek <pmladek@suse.com>
To: George Guo <dongtai.guo@linux.dev>
Cc: jpoimboe@kernel.org, jikos@kernel.org, mbenes@suse.cz,
	joe.lawrence@redhat.com, shuah@kernel.org,
	live-patching@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org, George Guo <guodongtai@kylinos.cn>
Subject: Re: [PATCH livepatch/master v1 2/2] selftests/livepatch: Replace
 hardcoded module name with variable in test-callbacks.sh
Message-ID: <Z0XKpjs53Da5nEvU@pathway.suse.cz>
References: <20241125112812.281018-1-dongtai.guo@linux.dev>
 <20241125112812.281018-2-dongtai.guo@linux.dev>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241125112812.281018-2-dongtai.guo@linux.dev>

On Mon 2024-11-25 19:28:12, George Guo wrote:
> From: George Guo <guodongtai@kylinos.cn>
> 
> Replaced the hardcoded module name test_klp_callbacks_demo in the
> pre_patch_callback log message with the variable $MOD_LIVEPATCH.
> 
> Signed-off-by: George Guo <guodongtai@kylinos.cn>

Reviewed-by: Petr Mladek <pmladek@suse.com>

Best Regards,
Petr

