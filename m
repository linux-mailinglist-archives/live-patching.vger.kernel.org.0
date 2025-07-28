Return-Path: <live-patching+bounces-1616-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D9820B14444
	for <lists+live-patching@lfdr.de>; Tue, 29 Jul 2025 00:16:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0E4AC18C15D6
	for <lists+live-patching@lfdr.de>; Mon, 28 Jul 2025 22:16:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBF0F22156C;
	Mon, 28 Jul 2025 22:16:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DGDy9uCu"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2244970813
	for <live-patching@vger.kernel.org>; Mon, 28 Jul 2025 22:16:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753740980; cv=none; b=d6G1MQi5PLC5pw7yIh/MaL+Gin7hVWuJc5NI7RruSvrZHwKpgDktH1wQEsF6Coqcq7C4+1EjA9qc+yabNzYW4P3qnjNz0Od6IGsuPXN6M+EG41JsdSr+GzMMyCQodi/w4TtSlyEHdTEarIx5DDbuJddMqO/cxUTH4gJq4mwcyWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753740980; c=relaxed/simple;
	bh=4Z6NO3fpfP3PkGAYr4VN3SdMP9a1cfmGhR3r/uvjDFQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iPcxUW7wt8vzTYoFozQigpY9owOJk0EHxY3tyM9j2letTx5eAERDkf3SETKNICDbRrOhscnju1lkV7as+2UVzGVloesu1dd9qbqKi9uo5KBo2/bmBNkNIQVpVokHKZwBWFXbQu22PjP8II3jASJrk2wlgO3vZGubK+w4gi2V+nI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DGDy9uCu; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753740977;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=fQLMDseKGWHJD2POGwLcDzuQw7GqfZnec1/2NK1Likk=;
	b=DGDy9uCuVHH3rR2bQoJhdV5nPB81aFwfS5VByVOYNa3M3UpheBx2JrufLVcezX5pLtZUmp
	ZOdG8SavRYjrYDPBEc+v4wWvpxXizn6xVZwTMTGwCM8HeCihr36ZTS5oFR18+d9xt4Xkty
	Lk3qlpauYXulhsZ/toW0sJLOmm1roA4=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-201-KbrhfnoqNzWnpT7exwOepg-1; Mon, 28 Jul 2025 18:16:16 -0400
X-MC-Unique: KbrhfnoqNzWnpT7exwOepg-1
X-Mimecast-MFC-AGG-ID: KbrhfnoqNzWnpT7exwOepg_1753740976
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-7e32b9398e4so642330385a.1
        for <live-patching@vger.kernel.org>; Mon, 28 Jul 2025 15:16:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753740976; x=1754345776;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fQLMDseKGWHJD2POGwLcDzuQw7GqfZnec1/2NK1Likk=;
        b=IljVsRElkXhnry3PJp6Ita0qqR8zcsZ6mijo5GDhA3DyjTLUPh4BYJNdH5+Q9kXPVV
         O15WneOnNguoeTmgR6ES+tzyYYeGCV3N498OczNL3enkVOtlF2O/is3eJ1hD4BGaeVrc
         aOoJN1/XW42grcig3Jh7t8FTooCDHkFjRoOZB464zTjU0p7v/zfd0H49o7DajtUsdDfr
         ScSySg6FhpHdtgN3fUQbYMFbZN8rXte1yTV8bArIEY/5S50S6NzDyuHHvsXBJeAZvFF7
         +GcQC0rh3p+jcAg4NiHB7VeEwMX1I1fs/GlG/qRD41NPxzZG+MXzzhKtJ7CMQ7Z2yU7W
         Irxg==
X-Gm-Message-State: AOJu0YywiyY77zlQ6xQhpfbm3gUTB/xt/Cb4BomWBYZoGy6MKyi0t2Q/
	uDQmo1vC1qQaGVW/AJcPJz3pdObuaRE8aCkvSJ8wMYcWJpec4R3+qL7AYj4tHA2Kkthd+JIpD19
	K86yzjW920sk0o3kFsRsx4HauQw026K3FB5IuJNkP3cE4v2zTozkAjn1ewSXN1zuxldU=
X-Gm-Gg: ASbGncuY9MyOosS8Z7N88XyevFKqLPf3PkL2hifVeo6fAJ1BqyeTj9dbyz3w8vh5prH
	CcLtfE6RnCTVRMpbbSyF2zq129ASMjUFurArqybI+n0GY7ya+3BC2S3MgY9rJZPcYApnC0tgcyk
	xpy/P+CwyyKVRl8gcRSLp6LqPRS+ca+15un2se0ufr59+HIvFSyhdC9CMjC2Mg5217/qx13zagT
	gn2gmFudww36OGbQIZ9AahbdgE+6ADzAmbAsWnWZ4eIrJ+dc02fMAkP9tsw1qmogaB3zmZjdlu+
	jaGBbNhADUqx1MffVHE9ZbL5ivtOUXgcgXGOUQQiiIbfsHziYbdcOadJaZZtHrJVWeD99tjkRNO
	vk+jjGw+0ppWdiFFlV7Y=
X-Received: by 2002:a05:620a:4115:b0:7e0:cb93:6fb1 with SMTP id af79cd13be357-7e63be38459mr1706409885a.9.1753740975675;
        Mon, 28 Jul 2025 15:16:15 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHQwOMA45NHxMdfz4vJNq3bTetD2CGSGS5/pyyMXVW/7CjvcbO1B0Dw4GZTowHILHIDFFoFhA==
X-Received: by 2002:a05:620a:4115:b0:7e0:cb93:6fb1 with SMTP id af79cd13be357-7e63be38459mr1706406385a.9.1753740975283;
        Mon, 28 Jul 2025 15:16:15 -0700 (PDT)
Received: from [192.168.1.17] (pool-68-160-160-85.bstnma.fios.verizon.net. [68.160.160.85])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7e64327aa0esm343713185a.12.2025.07.28.15.16.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Jul 2025 15:16:14 -0700 (PDT)
Message-ID: <fab6d382-fad4-4d91-90e0-2d0e9dfae216@redhat.com>
Date: Mon, 28 Jul 2025 18:16:13 -0400
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] kernel/livepatch/core: Fixed the issue of parsing failure
 caused by symbols carrying '-' generated by the kpatch software
To: Li kunyu <likunyu10@163.com>, jpoimboe@kernel.org, jikos@kernel.org,
 mbenes@suse.cz, pmladek@suse.com
Cc: live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250720205059.138877-1-likunyu10@163.com>
Content-Language: en-US
From: Joe Lawrence <joe.lawrence@redhat.com>
Autocrypt: addr=joe.lawrence@redhat.com; keydata=
 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
 pNzsRQ==
In-Reply-To: <20250720205059.138877-1-likunyu10@163.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/20/25 4:50 PM, Li kunyu wrote:
> A possible issue with the kpatch software was discovered during testing
> in the 6.6 and above kernel:
> livepatch: symbol .klp.sym.vmlinux-bringup_idt_table,5438511 has an
> incorrectly formatted name.
> 

Hmm, how did the dash get in the symbol name?  If I build a defconfig
x86_64 kernel from today, I see the "bringup_idt_table" symbol in
vmlinux, but as per Documentation/livepatch/module-elf-format.rst
shouldn't it be:

  .klp.sym.vmlinux.bringup_idt_table,<sympos>

(which btw, sympos of 5438511 seems a little bit large?)

Can you reference which kpatch-build project you are using (there are
several forks floating around, plus downstream versions) and then how to
reproduce this.

Thanks!

-- 
Joe


