Return-Path: <live-patching+bounces-1282-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 36AEDA65D64
	for <lists+live-patching@lfdr.de>; Mon, 17 Mar 2025 19:59:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5C7E616ABA0
	for <lists+live-patching@lfdr.de>; Mon, 17 Mar 2025 18:59:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E91C91DDC2C;
	Mon, 17 Mar 2025 18:59:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EPTbJuMB"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2571E18C337
	for <live-patching@vger.kernel.org>; Mon, 17 Mar 2025 18:59:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742237949; cv=none; b=Exjai7Wb3Q/brgnRIxfKXBUqOVQgVaNMvaYgwzAwfxdxIDr2tWEerOJ+9AMuXn+xkWc+j7xtJOQvFlxe2BfEtuguNhMkkQJrMsM6+ALnGFBcgYVvhNs1xTHYHClU2uTVTYNsYl0aCtedgJtzM5CWMCDPOs2wzeWvS5+Tu+iqoBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742237949; c=relaxed/simple;
	bh=8Mvcghslopvf1E/3deMZEcbFbof6wm2JxgmL6SNtdOI=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:From:Subject:
	 In-Reply-To:Content-Type; b=rZF+/iTgzFfeCMHiXPvng+IQN/qHy/wAwivVwLRFiu0dsSLxr8QCRro3wmATWP3ItBLwBmhGmIPVLnhHbwYRaUlqOMBNY3Im4bBV0lqIJGJbSXROoH5rI1EL2FC1QMb8Qqz9HjjSCmUknrA3R6yICnMBi9M7v2oO8tDE78mOXoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EPTbJuMB; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742237946;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UAC4P2Pq8sGOygMzCjk6tqP0Gbgx+vzhCMRMuM+aXHo=;
	b=EPTbJuMBf+oSIkXn85OeuddldyXuMZTwyH5EkjqFlxHEuqrhm1wwjDyUNeuoRlAjwsr7vD
	RzaNFGB+l/IO4E+FCMRgD3aB1lyIDqKaKVgmSfjkL+n/toAoiYGmgKAqxqs5g03Bk62vXh
	ThMpaLich2ZPKOg/gpzPbn7s/IvHzuQ=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-693-HWYMAAp7NyKUbpBjjzfBOw-1; Mon, 17 Mar 2025 14:59:05 -0400
X-MC-Unique: HWYMAAp7NyKUbpBjjzfBOw-1
X-Mimecast-MFC-AGG-ID: HWYMAAp7NyKUbpBjjzfBOw_1742237945
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-7c3c5e92d41so886122885a.1
        for <live-patching@vger.kernel.org>; Mon, 17 Mar 2025 11:59:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742237943; x=1742842743;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UAC4P2Pq8sGOygMzCjk6tqP0Gbgx+vzhCMRMuM+aXHo=;
        b=goGb8rh0vICd5pBdTJxAXmPvqYBUTFvBWfFA1UYr1xUkKI+SScICN7k67ngaxvbWvC
         Kd9I+s6Sek2Ht3LjP01LeTxYz0Y6a5minJYCMiXBZHY7aMCMVNAuA51j4qBrqCHHGhMa
         nlQESyehHxtCfsA+3MTE0jzjqLZq68GE8jldpMGAGgwOFpxVIIdHpMzEZeumGhXiUoEZ
         jzJHLgQJ7qw4euwdF5Hu46r+FYhAs46ECpOWl6YSt0KKFw34CsC83H2Iq88Z4AdQRT0M
         mTUsctmkMWEI+83bgFjBkaHvGoxl/t0tgrbXOL0WvccANL5aD5f/Qd4NaEcVnKO78pxf
         SdfQ==
X-Forwarded-Encrypted: i=1; AJvYcCW0wRVXWWYzvM2LpDCHn/YmJ6mRrkAfx1OdraB7RikUMyNKGU9+dGeWDPbUKUNtHT1s1os4jewTrvrP2Nwd@vger.kernel.org
X-Gm-Message-State: AOJu0YzW4Us/KCTlK/K47Zj9midZqB82DM8knWG6SiaEkGsOupKNuefR
	Q+OyCPwapIQFXXndYorC2wKEIRgYER95IAZZ5QrTEdnKCAP5WHcdDrHfVS1iLhr8/yyi3ctHxAk
	GwgLVEXKLBvbI4Bd5JEvyMlNjJnFHhzExdZFCyN3gbpuTuHF5TZKCG5UW7Q4Ngeo=
X-Gm-Gg: ASbGncsemSIILKoMj3/hFZEr2UkrlFR9rTR8VUOM+GhE0CgLumnwAtlEfYR2c5r6dUa
	5ZL1PgCdQLfhGLz0dWQJP+fjSj9L6n69FZSya3Ay4URwC6RDGx/tFK7zIGBXUchhmFp+nRG5to+
	hn8th5q/g6M0z/BxJ42YEJWGpA9UcgIulBw5qTI+rtpzDuJurA89JMPjqAPRh4BnASdkpR5pLWU
	88JT7qqavjo1FNaQCD+QxECHdgCvIB3qUUCS8O3xn5ZoUthv8veR1nqsnYf5UTbqQdQt4nm0r6d
	szVZz4bgZLAvYlV1pML18v3LI4oiyR33DC+O+apWUHI1aqce6grnlKKU3Ycr+N5iUs6lqsU=
X-Received: by 2002:a05:620a:2906:b0:7c5:48af:7f99 with SMTP id af79cd13be357-7c59b286360mr99671085a.35.1742237942879;
        Mon, 17 Mar 2025 11:59:02 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFtB7mLpsdw0aXSC7/ddwU1E1rL0ZJJ6gAUYx/ez2j2U5MijtbdWRuEJvx+HrjUCx9cu9hK2Q==
X-Received: by 2002:a05:620a:2906:b0:7c5:48af:7f99 with SMTP id af79cd13be357-7c59b286360mr99668185a.35.1742237942564;
        Mon, 17 Mar 2025 11:59:02 -0700 (PDT)
Received: from [192.168.1.11] (pool-68-160-160-85.bstnma.fios.verizon.net. [68.160.160.85])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7c573c55e95sm620489885a.17.2025.03.17.11.59.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Mar 2025 11:59:01 -0700 (PDT)
Message-ID: <2862567f-e380-a580-c3be-08bd768384f9@redhat.com>
Date: Mon, 17 Mar 2025 14:59:00 -0400
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Content-Language: en-US
To: Song Liu <song@kernel.org>, live-patching@vger.kernel.org
Cc: jpoimboe@kernel.org, kernel-team@meta.com, jikos@kernel.org,
 mbenes@suse.cz, pmladek@suse.com
References: <20250317165128.2356385-1-song@kernel.org>
From: Joe Lawrence <joe.lawrence@redhat.com>
Subject: Re: [PATCH] selftest/livepatch: Only run test-kprobe with
 CONFIG_KPROBES_ON_FTRACE
In-Reply-To: <20250317165128.2356385-1-song@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/17/25 12:51, Song Liu wrote:
> CONFIG_KPROBES_ON_FTRACE is required for test-kprobe. Skip test-kprobe
> when CONFIG_KPROBES_ON_FTRACE is not set.
> 
> Signed-off-by: Song Liu <song@kernel.org>
> ---
>  tools/testing/selftests/livepatch/test-kprobe.sh | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/tools/testing/selftests/livepatch/test-kprobe.sh b/tools/testing/selftests/livepatch/test-kprobe.sh
> index 115065156016..fd823dd5dd7f 100755
> --- a/tools/testing/selftests/livepatch/test-kprobe.sh
> +++ b/tools/testing/selftests/livepatch/test-kprobe.sh
> @@ -5,6 +5,8 @@
>  
>  . $(dirname $0)/functions.sh
>  
> +zgrep KPROBES_ON_FTRACE /proc/config.gz || skip "test-kprobe requires CONFIG_KPROBES_ON_FTRACE"
> +

Hi Song,

This in turn depends on CONFIG_IKCONFIG_PROC for /proc/config.gz (not
set for RHEL distro kernels).

Is there a dynamic way to figure out CONFIG_KPROBES_ON_FTRACE support?
Without looking into it very long, maybe test_klp_kprobe.c's call to
register_kprobe() could fail with -ENOTSUPP and the test script could
gracefully skip the test?

Regards,

-- 
Joe


