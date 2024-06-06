Return-Path: <live-patching+bounces-326-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F56F8FF0C6
	for <lists+live-patching@lfdr.de>; Thu,  6 Jun 2024 17:36:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C91E2B30FDC
	for <lists+live-patching@lfdr.de>; Thu,  6 Jun 2024 15:17:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DD7519AA66;
	Thu,  6 Jun 2024 15:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IaaHFZPZ"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6AE71974F3
	for <live-patching@vger.kernel.org>; Thu,  6 Jun 2024 15:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717686093; cv=none; b=Q5rc7yhPAdc2sWEcfNAUrzoAtRtKrOi7WiJSLviGs7tFTekag5FB/OD2nzwqJ04NcohKFNx/JHi+pFMorSPR3vsbEiF5zWX9BC9rxe46mZ2NWugk8SGpcNHXZXuGGgDD72allbdO7gff1MDcnkJfl5ctPLY6FglKlzBBJ27NE1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717686093; c=relaxed/simple;
	bh=O9MAf9qzp98/4x7roDH1u7DUx23gngi6st1Jji4B+Kc=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:From:Subject:
	 In-Reply-To:Content-Type; b=EDOpHApRO4xhWvQo54+w9SG4GMe1Eh2uZQNiuFqOyC5tnKUhxBM01FAqGTqnCjKBNGLLVkAhrJoyOFtesl3exStdL+5JHH2E38bCLiemHBV2Frk3DS7Skj6zuogofKpcMZt1fHhyU4YSUA0l9k0n0mK3dACOryemsLZFjj3jJAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IaaHFZPZ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717686090;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jBb5kFou/O0zRv4ZHMlU4A8XTDPpz2EYXqLmgDRH8kA=;
	b=IaaHFZPZjT+/8WhbaRC1FrQVDW9YgQBcmh0G5un7oKI1wIZ4JduS4hw77L4yhZmUO9f93T
	jtlr6Ms666Qg9UE/CEHeg0FEhJ/mOug4m47nNNEH43vp+nUPS4vRTi4vEYw5ghN41iERAJ
	lDW5X5vOYd7I1s9vCK0jzCXu/NrCiP8=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-568---FEEjbpPGCpNcC96TnD-Q-1; Thu, 06 Jun 2024 11:01:28 -0400
X-MC-Unique: --FEEjbpPGCpNcC96TnD-Q-1
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-6ae0dc954b2so15245066d6.0
        for <live-patching@vger.kernel.org>; Thu, 06 Jun 2024 08:01:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717686088; x=1718290888;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jBb5kFou/O0zRv4ZHMlU4A8XTDPpz2EYXqLmgDRH8kA=;
        b=uGt0XlSloH22Z+8a7Hw1AZMRHf4+8tMzcBxvmWtcCbsYfXTq0Eo+CXwmhU/h0S4aCk
         QJLouV22xVu7SYgp/ofVi5Tnypz4vm3ccNU6L9Q9qSfV4aZU0DkSt7EjCsWCYCGYBZdB
         h5Fdzi3xzudayAEMSr8a7ddC1NOiEg0GrV7ImMyQlJIYTP2bkaCTNjd6RLjGDdVTb00/
         y647/96WhHZg87WF4Cv5y3wiUZS6eRLMWaw+rKQyOxXpezQrr9j/VAfXZHKLChmUc+yI
         rGXFyKFUE87DjWGyn/sJi5CJ2HmQOBA7mbol5HHDyo6W9u5BQbOoRZGsjX4MZLzsIOIi
         IjPg==
X-Forwarded-Encrypted: i=1; AJvYcCXrYIH9MmANborLPUtlob7WppVxnDQio6JzXFT0JrRV7QDBVNMxCPWftZ+sUrvXo4jHLuN0oWJmiLQBwx4uFuH0xHa+Hn0oHvGdDsG83Q==
X-Gm-Message-State: AOJu0YyBNtkSOY+bg6troN6aKig+/zpPtjQhuiMWiiquL4Av8LIq8jzc
	p/Q7mP3t4noGCf9HBScQIf3i469Q/KymmaYoKUQAM/yvrXx6IAWznCyzkSd/D4xLhT1ulEKelO3
	0RJkQNJO6dAREprj5OHsJhfdk88/Euyt17SAKe6MTGm1j3bdeH2UBpRnqfShXcqs=
X-Received: by 2002:a05:6214:53c2:b0:6ae:ba6:2136 with SMTP id 6a1803df08f44-6b030a1f207mr73502556d6.36.1717686087423;
        Thu, 06 Jun 2024 08:01:27 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHRH7pcxj0JO5WLqrNYreesLzonwR/5WaCQB8j+jgwbAi0VAjzg+AL1oMiWygVgdyGzu8lrEg==
X-Received: by 2002:a05:6214:53c2:b0:6ae:ba6:2136 with SMTP id 6a1803df08f44-6b030a1f207mr73502266d6.36.1717686087022;
        Thu, 06 Jun 2024 08:01:27 -0700 (PDT)
Received: from [192.168.1.19] (pool-68-160-135-240.bstnma.fios.verizon.net. [68.160.135.240])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6b056fd8b14sm1958356d6.132.2024.06.06.08.01.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Jun 2024 08:01:26 -0700 (PDT)
Message-ID: <930d7361-64e9-a0fc-eb04-79d9bf9267fa@redhat.com>
Date: Thu, 6 Jun 2024 11:01:25 -0400
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Content-Language: en-US
To: zhang warden <zhangwarden@gmail.com>
Cc: Miroslav Benes <mbenes@suse.cz>, Josh Poimboeuf <jpoimboe@kernel.org>,
 Jiri Kosina <jikos@kernel.org>, Petr Mladek <pmladek@suse.com>,
 live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20240520005826.17281-1-zhangwarden@gmail.com>
 <alpine.LSU.2.21.2405200845130.11413@pobox.suse.cz>
 <BBD2A553-6D44-4CD5-94DD-D8B2D5536F94@gmail.com>
 <alpine.LSU.2.21.2405210823590.4805@pobox.suse.cz>
 <Zloh/TbRFIX6UtA+@redhat.com>
 <4DE98E35-2D1F-4A4E-8689-35FD246606EF@gmail.com>
 <Zl8mqq6nFlZL+6sb@redhat.com>
 <92FCCE66-8CE5-47B4-A20C-31DC16EE3DE0@gmail.com>
From: Joe Lawrence <joe.lawrence@redhat.com>
Subject: Re: [PATCH] livepatch: introduce klp_func called interface
In-Reply-To: <92FCCE66-8CE5-47B4-A20C-31DC16EE3DE0@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Wardenjohn,

To follow up, Red Hat kpatch QE pointed me toward this test:

https://gitlab.com/redhat/centos-stream/tests/kernel/kernel-tests/-/tree/main/general/kpatch/kpatch-trace?ref_type=heads

which reports a few interesting things via systemd service and ftrace:

- Patched functions
- Traced functions
- Code that was modified, but didn't run
- Other code that ftrace saw, but is not listed in the sysfs directory

The code looks to be built on top of the same basic ftrace commands that
I sent the other day.  You may be able to reuse/copy/etc bits from the
scripts if they are handy.

--
Joe


