Return-Path: <live-patching+bounces-742-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 7EFEC9A72BC
	for <lists+live-patching@lfdr.de>; Mon, 21 Oct 2024 20:57:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1A283B20F04
	for <lists+live-patching@lfdr.de>; Mon, 21 Oct 2024 18:57:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E67591FBC98;
	Mon, 21 Oct 2024 18:57:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="a56qPINK"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F33CB1FB3D4
	for <live-patching@vger.kernel.org>; Mon, 21 Oct 2024 18:57:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729537045; cv=none; b=CTc0HfO21SYoJS82/YPI8Hu79doiCmNR7ByQcgjfVNMsdr7Vg52P3RC1FaKjHhVxrKif2AP2lSMlajzOBe08WfibrfP/zrrqqaK+1zZhSZZZlELpB/ApMx5Nu091+eaHLgY6d3QmSmEgdVN+Mv44GTnX3ZH+Qcy+m0//gMOKl7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729537045; c=relaxed/simple;
	bh=Poj40m4XWjZmZW67V/R29Zyaoz6g/1vZbJUcwa8dRBw=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=OsWIh37r7tAoXltubIwnvE8LPn1QP0QM1SylrMOjrIxcpNcP4TWDpBDflCX0c5+URvGQ1KAs+/thIPj6xm1T2P1iIdmZSP+rL9svcbYerhxCWDPvWzD5cxdAz2I/g82F37DWlUuVdAYq4cr8B8BE1lGRL/gdCIbVBAdTD5pK70Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=a56qPINK; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729537036;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7JVcG4b9DpqHn6ILLTpsyd6A8EriJ9ALphdfVTy5yis=;
	b=a56qPINK0Q2cPJ0pOUaiw3DRx+WSwszRfXnkyTnpOuveIhYFM7fXGRG2ZDOZhb9xtpu5z/
	768rDncxYRZhPECVdPvBUcvYmxzLe/yuqMAAU+16ory1gJua/sdb/ZHanWmjzCjTQ5AJmQ
	DkprC3ev2Qw+vZvSvMFu+xi187MAQ3g=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-484-KhMR1BsINRCPHl1Yls7bmQ-1; Mon, 21 Oct 2024 14:57:15 -0400
X-MC-Unique: KhMR1BsINRCPHl1Yls7bmQ-1
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-6cbd2cb2f78so104767866d6.0
        for <live-patching@vger.kernel.org>; Mon, 21 Oct 2024 11:57:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729537035; x=1730141835;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7JVcG4b9DpqHn6ILLTpsyd6A8EriJ9ALphdfVTy5yis=;
        b=HqHEo6HyqJ23BEzM/w4OLPx6Mumm+SAV81IdGnDsRE2jJikpV835lg4RDyVB6qEcU5
         xSrcy9SF99P21hWcQ8ecidIJ+fxQYCQgZPFcguB47ySGCTpaEXTD9amCqmRAAdTVGAgM
         xb4NV3lLRPwWOflg4iHooTlR4cfLn7XbKk+z/eEFUpTClWFq2JVfbs7FCtlGWa997gkj
         Z2WVfma721GSo2Ff5SZnS8CgDi5ovnKIlaTVyhwJICEvH53Oh1c07ZaOAqSbEELFNYWG
         5x5R9jqRzeZpthD29o74NWlAaEFyeQmAFXK/nbUm1ykmuJw1ca2anIn3Xe9U4KKOIkbt
         a2gg==
X-Forwarded-Encrypted: i=1; AJvYcCVuq5D1HElH/wf4Cpe56N3FyXKZJmrPaq43oCAaDJLcNchLBPZkrwytdRyLAg6muHw7fwAgzp6IUCBrsB+A@vger.kernel.org
X-Gm-Message-State: AOJu0YyeySfnQVwNJZSrR5xod5UgrmxNRvaQvaR5zcJ0fWlC3m3PANx5
	0uqPKQDj6aLdChGcw/15p/66lMu3FfnFhEtg4wvgo+EUQjJCWwL3gKDPLvVjPefVfu+jHWZBECQ
	9s5L84DHF1JM1unm1wAY2hvpRilPyZfMgLi/OuWyO6JmmdE+Xh68VJWUG8Z5SXY8=
X-Received: by 2002:a05:6214:2dc7:b0:6cb:81ba:8ac1 with SMTP id 6a1803df08f44-6ce211dd0b9mr13770826d6.0.1729537033898;
        Mon, 21 Oct 2024 11:57:13 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFhRNbKYg3FJuhV3JjrTQoeIMJwfDsagQ1cKT7l7Ble51qnCXFHBL3v35PoAgmawwvbY02KeA==
X-Received: by 2002:a05:6214:2dc7:b0:6cb:81ba:8ac1 with SMTP id 6a1803df08f44-6ce211dd0b9mr13770476d6.0.1729537033558;
        Mon, 21 Oct 2024 11:57:13 -0700 (PDT)
Received: from [192.168.1.18] (pool-68-160-135-240.bstnma.fios.verizon.net. [68.160.135.240])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6ce008fb90dsm20433686d6.43.2024.10.21.11.57.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Oct 2024 11:57:13 -0700 (PDT)
Message-ID: <94cddfbb-bbef-73cc-2bb6-ad7474df08bf@redhat.com>
Date: Mon, 21 Oct 2024 14:57:12 -0400
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v5 0/3] selftests: livepatch: test livepatching a kprobed
 function
Content-Language: en-US
To: Michael Vetter <mvetter@suse.com>, linux-kselftest@vger.kernel.org,
 live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20241017200132.21946-1-mvetter@suse.com>
From: Joe Lawrence <joe.lawrence@redhat.com>
In-Reply-To: <20241017200132.21946-1-mvetter@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/17/24 16:01, Michael Vetter wrote:
> Thanks for all the reviews.
> 
> V5:
> Replace /sys/kernel/livepatch also in other/already existing tests.
> Improve commit message of 3rd patch.
> 
> V4:
> Use variable for /sys/kernel/debug.
> Be consistent with "" around variables.
> Fix path in commit message to /sys/kernel/debug/kprobes/enabled.
> 
> V3:
> Save and restore kprobe state also when test fails, by integrating it
> into setup_config() and cleanup().
> Rename SYSFS variables in a more logical way.
> Sort test modules in alphabetical order.
> Rename module description.
> 
> V2:
> Save and restore kprobe state.
> 
> Michael Vetter (3):
>   selftests: livepatch: rename KLP_SYSFS_DIR to SYSFS_KLP_DIR
>   selftests: livepatch: save and restore kprobe state
>   selftests: livepatch: test livepatching a kprobed function
> 
>  tools/testing/selftests/livepatch/Makefile    |  3 +-
>  .../testing/selftests/livepatch/functions.sh  | 29 +++++----
>  .../selftests/livepatch/test-callbacks.sh     | 24 +++----
>  .../selftests/livepatch/test-ftrace.sh        |  2 +-
>  .../selftests/livepatch/test-kprobe.sh        | 62 +++++++++++++++++++
>  .../selftests/livepatch/test-livepatch.sh     | 12 ++--
>  .../testing/selftests/livepatch/test-state.sh |  8 +--
>  .../selftests/livepatch/test-syscall.sh       |  2 +-
>  .../testing/selftests/livepatch/test-sysfs.sh |  8 +--
>  .../selftests/livepatch/test_modules/Makefile |  3 +-
>  .../livepatch/test_modules/test_klp_kprobe.c  | 38 ++++++++++++
>  11 files changed, 150 insertions(+), 41 deletions(-)
>  create mode 100755 tools/testing/selftests/livepatch/test-kprobe.sh
>  create mode 100644 tools/testing/selftests/livepatch/test_modules/test_klp_kprobe.c
> 

With the small syntax error fixed in unload_lp(),

Reviewed-by: Joe Lawrence <joe.lawrence@redhat.com>

Thanks, Michael, this is a good test to add to the suite.

-- 
Joe


