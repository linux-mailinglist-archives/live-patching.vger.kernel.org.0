Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6FD32FD8AE
	for <lists+live-patching@lfdr.de>; Wed, 20 Jan 2021 19:47:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388671AbhATSpl (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 20 Jan 2021 13:45:41 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:22504 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2391886AbhATSMf (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 20 Jan 2021 13:12:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611166269;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=r+rdpRSOqx0e5Um1NSM010H1HcWGo+y5f3OqsTp6gAE=;
        b=apuMhguiDHIyLqxuL/HNENyNCmW2grIJ1sprz0nUg8XBJKRADnGR9hS2wbhykcDySiLNSU
        Gyg3gQOF0xIQCDsNLu7c8Yxw8cu4/BXnamtHl4IHNea4hIu5rUzHVTz2wBaA5+xhVRK4G7
        DuASbRrB98vyDxtIfjlFRbyC7XHjqo0=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-344-A-4sQzR3N-SLe_bUKOhlRQ-1; Wed, 20 Jan 2021 13:11:06 -0500
X-MC-Unique: A-4sQzR3N-SLe_bUKOhlRQ-1
Received: by mail-wr1-f70.google.com with SMTP id r8so11959711wro.22
        for <live-patching@vger.kernel.org>; Wed, 20 Jan 2021 10:11:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=r+rdpRSOqx0e5Um1NSM010H1HcWGo+y5f3OqsTp6gAE=;
        b=GiXHyFFcUmwc8xqt0DSyhAEqo1D88IJIG4Vg7ftK35d9yJWKYxqTDAD9/sUqSzmfNm
         Z26UWVmRm8I5ocbwB5cKkB1OBU7ek6E6kTPAJYbCyNVQkCjEw2GaznqY15xtiDQJ/8T2
         JAkNkCEfZYbV5TUP3R6P41WE1hxvHw3+aSOl4zkEFvEiYbGPTObkYF43lQdCvcAyjzB/
         XQL6ZFqtvLMuPI32Gdq5k53H/hyIxGHIZ5HKdYen0dMxz/aAWn4mc/cGuH5fnh5iyacQ
         5seLqh6XfDflZCdIon9/YNohyasN5eUanmyes4loSF8sMxw4LaQeTc3llHrtTnd8LWLa
         0GxQ==
X-Gm-Message-State: AOAM5304WiT3plqty2hVpi7rrHbxChLeotp0s/wpNvSxUnnjvFwUhWi4
        uje955RYCS/S4N+NnmA5bWw8M/U4kGk6paqoB0Ith+W3gS69LRAtUlaNvMD8PD0Xo6DWGQxtoaa
        cmx8em+yDzkSfH3JqYekPUMm0sQ==
X-Received: by 2002:adf:fbd2:: with SMTP id d18mr10723061wrs.222.1611166264940;
        Wed, 20 Jan 2021 10:11:04 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx712Nf6ZKaG9Jo2uAax6LE/sAn/qhhDWtpCKz/UcyiauPjShsbvk20cwqythG/pVi2ehZ8BQ==
X-Received: by 2002:adf:fbd2:: with SMTP id d18mr10723047wrs.222.1611166264802;
        Wed, 20 Jan 2021 10:11:04 -0800 (PST)
Received: from ?IPv6:2a01:cb14:499:3d00:cd47:f651:9d80:157a? ([2a01:cb14:499:3d00:cd47:f651:9d80:157a])
        by smtp.gmail.com with ESMTPSA id g14sm6087511wru.45.2021.01.20.10.11.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Jan 2021 10:11:04 -0800 (PST)
Subject: Re: Live patching on ARM64
To:     "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>,
        Mark Rutland <mark.rutland@arm.com>
Cc:     linux-arm-kernel@lists.infradead.org,
        Mark Brown <broonie@kernel.org>, jpoimboe@redhat.com,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
References: <f3fe6a60-9ac2-591d-1b83-9113c50dc492@linux.microsoft.com>
 <20210115123347.GB39776@C02TD0UTHF1T.local>
 <a5f22237-a18d-3905-0521-f0d0f9c253ea@linux.microsoft.com>
 <1cd6ab9a-74bc-258e-abf8-fcabba5e3484@redhat.com>
 <32ec8721-90d6-c93d-f6f3-926c8876235b@linux.microsoft.com>
From:   Julien Thierry <jthierry@redhat.com>
Message-ID: <1f30b295-b307-ad61-b7f5-8cd55bc246d1@redhat.com>
Date:   Wed, 20 Jan 2021 19:11:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <32ec8721-90d6-c93d-f6f3-926c8876235b@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hi,

On 1/19/21 4:19 PM, Madhavan T. Venkataraman wrote:
> 
>> Sorry for the late reply. The last RFC for arm64 support in objtool is a bit old because it was preferable to split things into smaller series.
>>
>> I touched it much lately, so I'm picking it back up and will try to get a git branch into shape on a recent mainline (a few things need fixing since the last time I rebased it).
>>
>> I'll update you once I have something at least usable/presentable.
>>
>> Cheers,
>>
> 

I just sent some series the arm64 objtool support:
- https://lkml.org/lkml/2021/1/20/791
- 
https://lore.kernel.org/linux-arm-kernel/20210120173800.1660730-1-jthierry@redhat.com/T/#t

There are still some things missing, so if you want to investigate a 
more complete state I have a branch:
$ git clone https://github.com/julien-thierry/linux.git -b 
objtoolxarm64-latest

Let me know if there are any questions related to it.

Cheers,

-- 
Julien Thierry

