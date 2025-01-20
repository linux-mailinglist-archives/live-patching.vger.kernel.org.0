Return-Path: <live-patching+bounces-1012-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 642A7A16FD3
	for <lists+live-patching@lfdr.de>; Mon, 20 Jan 2025 17:07:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9568C160C30
	for <lists+live-patching@lfdr.de>; Mon, 20 Jan 2025 16:07:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 960A01E7C16;
	Mon, 20 Jan 2025 16:07:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="C1R8ISwS"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D2E710F9
	for <live-patching@vger.kernel.org>; Mon, 20 Jan 2025 16:07:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737389224; cv=none; b=V/Jhy5ZhX3JrPGnaMMxeA05BGbaHaO7ACWXnj7jTZYYLZ2XbW8aEOZeMmyqRNvBPGqPvVFCCHdpfs8ITqT45RgWjqg8LlkaiQdwp4UR+vvJDkTWADJblaeqRsbQ3pR+8FZTlvQXdMImtsnhxn5anZ1MfgEZtdXhyXZDfI2NCORs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737389224; c=relaxed/simple;
	bh=xJGsasntfSsdEyCTjSTe+dS44QgKBn6VDNudjx7WRPk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c0+XqCXu3yHlmeeEY3bNty78uzN+kXgZBFQkV5Do0PU394shC2t3l1OOx6iGfT/pU/o3R4WKIhwKVmRuvTZTTAclfbSEf2Zq8v6aSKRkmvuvIu9eA9q5kiMwSgDKhfbt11s6q/gf+jaAGdIVF1xIhFMBAPXz33GlNJ1v5wqDcIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=C1R8ISwS; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-385e0e224cbso2452972f8f.2
        for <live-patching@vger.kernel.org>; Mon, 20 Jan 2025 08:07:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1737389221; x=1737994021; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=w2kqVj/vNWaOIWjGL7Wo52uGPlsoab4Shov7lcOaDwM=;
        b=C1R8ISwSBREaHKeq42QeJo3ZyNzXyGy9GljDtZ1MTiPH+aRC1PQMU6Pf+7K0Ebiv+d
         jA3xan3LTWdgriimx+hDWQM+VkZOaB6gbyuw+aaWKU1oqH0OSjXEYlG2G8ACL2Bg02gt
         qhPF788+1rnc3wCcUX4JjK2TWMzpESmUQs3pcWTLoP0hUv3CDcj+ApNFCtqdJt52k07s
         1CoNF6bSXNcSXLG4MTe2IbogVU7oz03B4EcF+a+kCxU792Z3sSqmzn+IlDrgjY6bKdKA
         x9bFPv1h7nCedZKRqc2mXEvPZAqiYrULyyen+/LDy1v9pKP0ltZYAzzOed+O1Bh+slAP
         fd0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737389221; x=1737994021;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=w2kqVj/vNWaOIWjGL7Wo52uGPlsoab4Shov7lcOaDwM=;
        b=NXz/ezZOpOMhJVqIUjl8593Ec7qi9TIVR/iRllgUrSDlSKvA2tgGV1wnX7/7bVhmGj
         DFydjkWAQWQQWzp9tfI4GJ0Gtsfyx9aVNg4kg4U/epLsV+Nstoa20KXZwT3Walq3+X7b
         Whjz2Y/ASvlQlSdljU8FsIMtnDCeAvf2pcagLC35SRwW24aidPO50nC1yH4R/xz7kFKh
         VuxB/32utuHPhrToxQNPVpKoYM1TjFC6kWOV2Mn1pG6iSsPKs3kg8k+86aeBIToVlA88
         fxqSllm553jL8p1X37I82kZkTNEt+4bOtCZo+D3tT+v7P1s1mXeUO2UryJZx2PqbIlf6
         +/5g==
X-Forwarded-Encrypted: i=1; AJvYcCWyFz8f5sJYPpkLTnXfgqcUuX80990IhMmBUDqpeAd4KKpHqY9dSUDHSHIFkXabutS/2uhYK5gOncw8GTzj@vger.kernel.org
X-Gm-Message-State: AOJu0Yw5zNAz+PEkItHkftaJcfl6VX/R+TvJ3Cxh+YTw5tUlgnPsKDym
	o4ce5M2gN6FFBvrLJwVHAkF5UqktGYIS1Z0oyiJoEAIqOxDvOrUzAdD+yQV39Qk=
X-Gm-Gg: ASbGncv0txiwZ+QckFlha7k+CZoCEIF/s+rSFgJwfrNv0v98r1DkgryhZsZOUdmqt33
	6RugplPD7af8sXKh2gi+JTHeruicCmYrGSYYmyFCyzausRFbcRSzrcYYNssnEc+TqXmYnv+GRFQ
	2JoIh/JnecSV67xb9eREN34ZcoHmfmKmpIH9XE/lHJw6GGOClaHgF2HoOfli34xUq8C0K5phOv0
	hQfT/cnBy2qV7UU9jhMWE0tA0n/JIHe7PGQ4C6tz+ARk4Hg/IUE43ckpSuN8izHoazWZSc=
X-Google-Smtp-Source: AGHT+IHblmvdT66NUAONbYDv1+zr0khDyHKPPgNGnZvOkmFzzDFs2TXnIxu6R3PeoRXgYqp5XmXoeg==
X-Received: by 2002:a05:6000:1548:b0:385:f19f:5a8f with SMTP id ffacd0b85a97d-38bf5655594mr10417912f8f.4.1737389220704;
        Mon, 20 Jan 2025 08:07:00 -0800 (PST)
Received: from pathway.suse.cz ([176.114.240.50])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-437c74c4751sm202802545e9.19.2025.01.20.08.06.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jan 2025 08:07:00 -0800 (PST)
Date: Mon, 20 Jan 2025 17:06:58 +0100
From: Petr Mladek <pmladek@suse.com>
To: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: jikos@kernel.org, mbenes@suse.cz, joe.lawrence@redhat.com,
	shuah@kernel.org, mpe@ellerman.id.au, npiggin@gmail.com,
	christophe.leroy@csgroup.eu, naveen@kernel.org,
	live-patching@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v2] selftests: livepatch: handle PRINTK_CALLER in
 check_result()
Message-ID: <Z450ohzYtxVEMh1_@pathway.suse.cz>
References: <20250119163238.749847-1-maddy@linux.ibm.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250119163238.749847-1-maddy@linux.ibm.com>

On Sun 2025-01-19 22:02:38, Madhavan Srinivasan wrote:
> Some arch configs (like ppc64) enable CONFIG_PRINTK_CALLER,
> which adds the caller id as part of the dmesg. With recent
> util-linux's update 467a5b3192f16 ('dmesg: add caller_id support')
> the standard "dmesg" has been enhanced to print PRINTK_CALLER fields.
> 
> Due to this, even though the expected vs observed are same,
> end testcase results are failed.
> 
>  -% insmod test_modules/test_klp_livepatch.ko
>  -livepatch: enabling patch 'test_klp_livepatch'
>  -livepatch: 'test_klp_livepatch': initializing patching transition
>  -livepatch: 'test_klp_livepatch': starting patching transition
>  -livepatch: 'test_klp_livepatch': completing patching transition
>  -livepatch: 'test_klp_livepatch': patching complete
>  -% echo 0 > /sys/kernel/livepatch/test_klp_livepatch/enabled
>  -livepatch: 'test_klp_livepatch': initializing unpatching transition
>  -livepatch: 'test_klp_livepatch': starting unpatching transition
>  -livepatch: 'test_klp_livepatch': completing unpatching transition
>  -livepatch: 'test_klp_livepatch': unpatching complete
>  -% rmmod test_klp_livepatch
>  +[   T3659] % insmod test_modules/test_klp_livepatch.ko
>  +[   T3682] livepatch: enabling patch 'test_klp_livepatch'
>  +[   T3682] livepatch: 'test_klp_livepatch': initializing patching transition
>  +[   T3682] livepatch: 'test_klp_livepatch': starting patching transition
>  +[    T826] livepatch: 'test_klp_livepatch': completing patching transition
>  +[    T826] livepatch: 'test_klp_livepatch': patching complete
>  +[   T3659] % echo 0 > /sys/kernel/livepatch/test_klp_livepatch/enabled
>  +[   T3659] livepatch: 'test_klp_livepatch': initializing unpatching transition
>  +[   T3659] livepatch: 'test_klp_livepatch': starting unpatching transition
>  +[    T789] livepatch: 'test_klp_livepatch': completing unpatching transition
>  +[    T789] livepatch: 'test_klp_livepatch': unpatching complete
>  +[   T3659] % rmmod test_klp_livepatch
> 
>   ERROR: livepatch kselftest(s) failed
>  not ok 1 selftests: livepatch: test-livepatch.sh # exit=1
> 
> Currently the check_result() handles the "[time]" removal from
> the dmesg. Enhance the check to also handle removal of "[Thread Id]"
> or "[CPU Id]".
> 
> Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>

Looks and works well:

Reviewed-by: Petr Mladek <pmladek@suse.com>
Tested-by: Petr Mladek <pmladek@suse.com>

Best Regards,
Petr

PS: The merge window for 6.14 has started yesterday. Every change
    should spend at least few days in linux-next and I have already
    sent a pull request so it is kind of late for 6.14.

    If there is a demand, I could still queue it for 6.14 in the 2nd
    half of the merge window or for rc2. There is only small group
    of people interested into the livepatch selftests anyway.

