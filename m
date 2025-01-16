Return-Path: <live-patching+bounces-1003-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B9538A13A8A
	for <lists+live-patching@lfdr.de>; Thu, 16 Jan 2025 14:10:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E08C51620EC
	for <lists+live-patching@lfdr.de>; Thu, 16 Jan 2025 13:10:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0566D1EE01C;
	Thu, 16 Jan 2025 13:10:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PURTmw8v"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 541F91DE4DF
	for <live-patching@vger.kernel.org>; Thu, 16 Jan 2025 13:10:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737033053; cv=none; b=gohG+42tUKBfy+gMr/up3bMDNh9TvRXZh9oUc6qBBGTlmzxpMGFXtmBUgTOoF35uk6gBvovFiGJaE114mVNqbwbLsCEXtU1EY31HdPc+AEhffhP/cWb3KC0sbvUKZISqySTVXQuEaPmDdsozN83LYubCRgtuQtceCZQpMLaLOJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737033053; c=relaxed/simple;
	bh=+hFxKwknvMre/hP5tDMH/Cxc7Oez08BLSgcYveXDaas=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:From:Subject:
	 In-Reply-To:Content-Type; b=W8+GkLjT3ltP+bUesC8CSlHc8iDXivCkjRH3u3ZFKRJ5LiaUfE4T1AkpU37aG44jTwQM5VmcNOgYubdNV7RvkMnjZHMPxAw0lmN304g0l7rfd7vQEOJ6VoNt2LCYApOZJs8/cjtB7PVLXx4z6c+PuMhge7SAiWMUnx/ao2Q6FcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PURTmw8v; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737033051;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tJE6q01qSH3/mfQ6O3cCJzFIbn2hHMAntoS6R0p7Vw4=;
	b=PURTmw8vfWQpVV2W4fAx7kAIdFiA3w3YZaq/XE2kE7W28SLb2nzvV/EyakgjGtTVz086rR
	gVuH6/hjUcFFm50Kh9F8JJOPTZDOCLl0c9Y+G0Ki9C9SweZ3Qb7Dsg/ebrG9X/m7gg5ASX
	O77VZPh76btLTkL1ZLcoPyooUfuW2cg=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-111-stVVEkLENAWnFeYzFtLHVQ-1; Thu, 16 Jan 2025 08:10:50 -0500
X-MC-Unique: stVVEkLENAWnFeYzFtLHVQ-1
X-Mimecast-MFC-AGG-ID: stVVEkLENAWnFeYzFtLHVQ
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-21681a2c0d5so18675145ad.2
        for <live-patching@vger.kernel.org>; Thu, 16 Jan 2025 05:10:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737033049; x=1737637849;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tJE6q01qSH3/mfQ6O3cCJzFIbn2hHMAntoS6R0p7Vw4=;
        b=fcB/DYoUe02HlvwiIaU8ftYh6fks33MJRlWVgl+bz0DNWpPqTbfOyPuOr+/MOvmky1
         ab1ivRcXIs94dsuOse8H0iAGZzngZztdGqzwZ/wVo2/sMmQaqXG/vt8z310E3sciB16x
         YYGZ9b3YjBoZDZoyEoYw7dTWIprJV+EgPFGrsID8jiOtf8EJ/Q+lVfJF/UJXXam1tdZx
         /fiOt7RHgWQfr4qWgdh7BS7REOMauufNTxCajcC+Q0kiBQPFVjb4yfg4HjZH3K1MugjS
         dU70JwSJymX/9Wyjl0PscxJu8i7NHcK2UxY0VOfo7sn4iMIe+9EJxSvheZu8fDvoYgig
         9Nzw==
X-Forwarded-Encrypted: i=1; AJvYcCUDBTaUymZt+tUUB5wGS3uvPb7Xe4zqzEaj1YDVnsuwpBEF7XaOzSmHz/GRPx5+dh6M0cQFVZ6oxRC7EIe8@vger.kernel.org
X-Gm-Message-State: AOJu0YxQB62OPvPqfQiUbQrFuVnC4YBE86fBxDMuDxt8VTWSZl0350RS
	QCrBLKpXGE068dgma6Z/u4pW0x5wSQwoInTuXcv1UX79H6KwjDNFlUsT46QAkaTdI10j/wGU5Sc
	9HWtkYjy4umrxm/0GyxhchffqS+EOKUmiqB3yignaj3+mQqR3z3JJtdSujuOgR90=
X-Gm-Gg: ASbGnctdPlTo3mqOTKvepFLrWM7tG5AHCt7+kz5i0G2VOFXWR0PpOus+TYXOfQtZcv8
	39gmCD5jgXQHHU/RIBSorTYjRs/dD1cEDi+zOG3PJyOaU7cIKpmq9M+97PuXnZQD8aGesUGIpIZ
	NAlADpyRo5GZl+U/nTBLxAo2j7W8YApAT5jUttY9G0ft/jN1wihdLDHKWnKiZ9Sxfs/Peqn4oIV
	FZyccW5BlCRjHmZWWTZdZeJn1d7quNkE7Lh5G+pLQ8zSx0RhT0DCZuKvkpi9QsTVk6by8UluH9N
	DrigjT3Y5VWvLvFGKTiMGTuHqqSiiHECQzTQ5rg=
X-Received: by 2002:a05:6a20:2d22:b0:1e0:d0c8:7100 with SMTP id adf61e73a8af0-1e88d0dfa37mr60732741637.7.1737033049098;
        Thu, 16 Jan 2025 05:10:49 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHUGbKF+ol54jU0b50uVW9b4PehX8H1D/kojXZ6K7dXSPvbGWangj+PbIkDc2rYIOeEmnulwA==
X-Received: by 2002:a05:6a20:2d22:b0:1e0:d0c8:7100 with SMTP id adf61e73a8af0-1e88d0dfa37mr60732683637.7.1737033048617;
        Thu, 16 Jan 2025 05:10:48 -0800 (PST)
Received: from [192.168.1.46] (pool-68-160-135-240.bstnma.fios.verizon.net. [68.160.135.240])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72d40658c4bsm11140160b3a.100.2025.01.16.05.10.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Jan 2025 05:10:48 -0800 (PST)
Message-ID: <af77083e-2100-ea2e-ae14-dc5761456fef@redhat.com>
Date: Thu, 16 Jan 2025 08:10:44 -0500
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Content-Language: en-US
To: Petr Mladek <pmladek@suse.com>, Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: jikos@kernel.org, mbenes@suse.cz, shuah@kernel.org, mpe@ellerman.id.au,
 npiggin@gmail.com, christophe.leroy@csgroup.eu, naveen@kernel.org,
 live-patching@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org
References: <20250114143144.164250-1-maddy@linux.ibm.com>
 <Z4jRisgTXOR5-gmv@pathway.suse.cz>
From: Joe Lawrence <joe.lawrence@redhat.com>
Subject: Re: [PATCH] selftests: livepatch: handle PRINTK_CALLER in
 check_result()
In-Reply-To: <Z4jRisgTXOR5-gmv@pathway.suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/16/25 04:29, Petr Mladek wrote:
> On Tue 2025-01-14 20:01:44, Madhavan Srinivasan wrote:
>> Some arch configs (like ppc64) enable CONFIG_PRINTK_CALLER, which
>> adds the caller id as part of the dmesg. Due to this, even though
>> the expected vs observed are same, end testcase results are failed.
> 
> CONFIG_PRINTK_CALLER is not the only culprit. We (SUSE) have it enabled
> as well and the selftests pass without this patch.
> 
> The difference might be in dmesg. It shows the caller only when
> the messages are read via the syslog syscall (-S) option. It should
> not show the caller when the messages are read via /dev/kmsg
> which should be the default.
> 
> I wonder if you define an alias to dmesg which adds the "-S" option
> or if /dev/kmsg is not usable from some reason.
> 

Hi Petr,

To see the thread markers on a RHEL-9.6 machine, I built and installed
the latest dmesg from:

  https://github.com/util-linux/util-linux

and ran Madhavan's tests.  I don't think there was any alias involved:

  $ alias | grep dmesg
  (nothing)

  $ ~/util-linux/dmesg | tail -n1
  [ 4361.322790] [  T98877] % rmmod test_klp_livepatch

From util-linux's 467a5b3192f1 ("dmesg: add caller_id support"):

 The dmesg -S using the old syslog interface supports printing the
 PRINTK_CALLER field but currently standard dmesg does not support
 printing the field if present. There are utilities that use dmesg and
 so it would be optimal if dmesg supported PRINTK_CALLER as well.

does that imply that printing the thread IDs is now a (util-linux's)
dmesg default?

Regards,

-- 
Joe


