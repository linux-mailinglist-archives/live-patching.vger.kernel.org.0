Return-Path: <live-patching+bounces-509-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5429B95BD18
	for <lists+live-patching@lfdr.de>; Thu, 22 Aug 2024 19:25:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F2D191F23B58
	for <lists+live-patching@lfdr.de>; Thu, 22 Aug 2024 17:25:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57F6B1CEADD;
	Thu, 22 Aug 2024 17:25:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dP9k/wU2"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F4991CEAB6
	for <live-patching@vger.kernel.org>; Thu, 22 Aug 2024 17:25:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724347507; cv=none; b=p2FNZLRQHvF0lWDUBOBVD7HPKNq9oL2s45v8uR7oASswlVuBhR7dLrc8/Unb0SeL2S6stf8BIzUJffvfxi8E2YvtZjsM5d0p/AuUnrSzDOFk15E6o2nPXKSZMyoLyRw2miZGKK84UMOqgJSpy3eOH6sDw5piC0pdpqWJZiqVK7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724347507; c=relaxed/simple;
	bh=96nSAerh6X2V4FpypOy6E5j6+AHv5vX7RJ+JzdUuYZI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=M00D7Gm8nb6LDYZaa3dWAhp9L+2E/Bqt04p/pzZyEMv2a+4E9Pe/tX+AjH/AbkH46IOFROc0Hq2ZyUlfYKW3HNAL+Bko6/z/1gHfeu/YdYINjCBro+PRg+xvzMJFN6XnYD7clFfIIGX2egKU+aS9mnMYpx4JNSrotxJddIx3FcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dP9k/wU2; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724347504;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=d3xzI8Z49dbNRaboDk3FVrW8VSVdcJeyT4KaTegTimQ=;
	b=dP9k/wU2nXJk6KZpJv9Cjpo6K6NFO7gUgp6PgxVXaMhxgrDYIaBE2f6pC8u+98HfhnI2IS
	AYEzWykm5skDm8GMs0l7vBzYT1dRy/mqmyMSJgpRMrNEuhMsLYXvOQvfInPb+pXZigEKJd
	jV2Y7QOsl68cRGDfrq+vl6hqdqs2Ke0=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-533-E6_DiBR0NhaYBPt72-k_vg-1; Thu, 22 Aug 2024 13:25:02 -0400
X-MC-Unique: E6_DiBR0NhaYBPt72-k_vg-1
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-7a1dbbe6e4cso125048885a.3
        for <live-patching@vger.kernel.org>; Thu, 22 Aug 2024 10:25:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724347502; x=1724952302;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=d3xzI8Z49dbNRaboDk3FVrW8VSVdcJeyT4KaTegTimQ=;
        b=cBfb/gtJ60CAt3TUV8lYkWh5/06DbKtkJl7EAUD135eG9FJ8YS+5bIRKbbrslWYWty
         kFGfaETE5hNFFR2rLHZbsgmNbIxI9iWLZ48jgwF2BLoHunAuUZtZyX5z30szZdK+sxJ2
         pVGmfGVhFe/8zk2/MT7stJHq+AepbgtIxz28bAtP+Q1qKD0dOmKQT7F1zOGGqCpa8sem
         tg5GaB4GV54vXrCg3efGcHsFwvk/vuMCjDAs1nONpF34jIj31pGfSKKJ4/EnqMlPLGJX
         1AAGCul33JpLrkXa3LIFtF7gl4P1keqicC9TPksELri+z1f3drCnzwbmZMwnhAnPKQjK
         A1wg==
X-Forwarded-Encrypted: i=1; AJvYcCWHxFHfglJZvWrHuYXVEpLyJJxnbtt2qE4LNRuWud3Ygi/TGjThe9Dv4mDrSLy0xYX/p75B54vEtsNP6yg7@vger.kernel.org
X-Gm-Message-State: AOJu0Yys3Atq2Tfk9HrXcbWH3KgeHXYkIOpKNowUE5fk4TdsM+AAlIC6
	Z0gkS6qPgHhu2BjptHlqyDLQ/qikRdIdacwG6+5GSksMfs/bDRycMo86PcKNuahQ0Gs5/SCs42C
	LyU5AionxmW35TdLONz3cva3KAACLMwqqJOEAqxzqeYlwwpTS1lEjVsfUpj+2Axs=
X-Received: by 2002:a05:620a:1a1d:b0:79d:5f82:a404 with SMTP id af79cd13be357-7a680b223famr316026585a.64.1724347501876;
        Thu, 22 Aug 2024 10:25:01 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFiVZLnwMjRH6QJCF0rkI5pAHMrm7yzrb/gyVCV7b3SHnoFL/3+AI7zTBVhdN8BbXo7qHzyWQ==
X-Received: by 2002:a05:620a:1a1d:b0:79d:5f82:a404 with SMTP id af79cd13be357-7a680b223famr316024085a.64.1724347501514;
        Thu, 22 Aug 2024 10:25:01 -0700 (PDT)
Received: from [192.168.1.9] (pool-68-160-135-240.bstnma.fios.verizon.net. [68.160.135.240])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7a67f347b15sm91442485a.44.2024.08.22.10.25.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Aug 2024 10:25:00 -0700 (PDT)
Message-ID: <182e7c5a-b8cc-6ac1-7edf-81c092be72f5@redhat.com>
Date: Thu, 22 Aug 2024 13:24:59 -0400
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH] selftests/livepatch: wait for atomic replace to occur
Content-Language: en-US
To: Ryan Sullivan <rysulliv@redhat.com>, live-patching@vger.kernel.org,
 linux-kselftest@vger.kernel.org
Cc: jpoimboe@kernel.org, jikos@kernel.org, mbenes@suse.cz, pmladek@suse.com,
 shuah@kernel.org
References: <20240822163439.13092-1-rysulliv@redhat.com>
From: Joe Lawrence <joe.lawrence@redhat.com>
In-Reply-To: <20240822163439.13092-1-rysulliv@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 8/22/24 12:34, Ryan Sullivan wrote:
> Uses 'loop_until' to wait for the atomic replace to unload all previous
> livepatches, as on some machines with a large number of CPUs there is a
> sizable delay between the atomic replace ocurring and when sysfs
> updates accordingly.
> 

Small nit: flip this around so it describes the problem first, then the
'loop_util' solution.  Also spell check "occurring" if you keep it 😄

> Signed-off-by: Ryan Sullivan <rysulliv@redhat.com>

Let's give the CKI credit for finding this:
Reported-by: CKI Project <cki-project@redhat.com>

If anyone is interested, here is the test/log link:
https://datawarehouse.cki-project.org/kcidb/tests/redhat:1413102084-x86_64-kernel_upt_28

By the way, was it easy to repro on a similar machine as the one
reported by CKI and then how did it fare with this patch in place?

> ---
>  tools/testing/selftests/livepatch/test-livepatch.sh | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)
> 
> diff --git a/tools/testing/selftests/livepatch/test-livepatch.sh b/tools/testing/selftests/livepatch/test-livepatch.sh
> index 65c9c058458d..bd13257bfdfe 100755
> --- a/tools/testing/selftests/livepatch/test-livepatch.sh
> +++ b/tools/testing/selftests/livepatch/test-livepatch.sh
> @@ -139,11 +139,8 @@ load_lp $MOD_REPLACE replace=1
>  grep 'live patched' /proc/cmdline > /dev/kmsg
>  grep 'live patched' /proc/meminfo > /dev/kmsg
>  
> -mods=(/sys/kernel/livepatch/*)
> -nmods=${#mods[@]}
> -if [ "$nmods" -ne 1 ]; then
> -	die "Expecting only one moduled listed, found $nmods"
> -fi
> +loop_until 'mods=(/sys/kernel/livepatch/*); nmods=${#mods[@]}; [[ "$nmods" -eq 1 ]]' ||
> +        die "Expecting only one moduled listed, found $nmods"
>  
>  # These modules were disabled by the atomic replace
>  for mod in $MOD_LIVEPATCH3 $MOD_LIVEPATCH2 $MOD_LIVEPATCH1; do

With commit msg additions above:

Acked-by: Joe Lawrence <joe.lawrence@redhat.com>

Thanks,

-- 
Joe


