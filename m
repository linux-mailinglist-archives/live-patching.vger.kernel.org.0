Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 057374878B3
	for <lists+live-patching@lfdr.de>; Fri,  7 Jan 2022 15:13:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239127AbiAGONN (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 7 Jan 2022 09:13:13 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:33275 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239025AbiAGONN (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 7 Jan 2022 09:13:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641564792;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2L4YEi0aDoHLNeQF/we9qhhc3irCTkuMiMi3Iny+wp0=;
        b=RXWEO5kUivo8zJtXAcXpT2aKXarUSQer69rrTu+/tOFjSWSuxIpwsePdZ37R5b63KTbQpf
        t1DZA8HOhtEsjYEj3NcBweIU3jec3cYa0OYEDB6xOoM9iCgBUlA+mIuEIz01FzRU+9NGSM
        dATu6Z2qlAjGucELUaTB927AvrSVuZw=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-479-g5tYbWFmPgqWI2X5h5tWdg-1; Fri, 07 Jan 2022 09:13:10 -0500
X-MC-Unique: g5tYbWFmPgqWI2X5h5tWdg-1
Received: by mail-qv1-f71.google.com with SMTP id gf14-20020a056214250e00b00411ba2ba63dso4867934qvb.21
        for <live-patching@vger.kernel.org>; Fri, 07 Jan 2022 06:13:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:to:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2L4YEi0aDoHLNeQF/we9qhhc3irCTkuMiMi3Iny+wp0=;
        b=cdXuyyvE3NsX420qDDn++AjnbyhaGabdVJIxHlhdfDJZRxNQVnWNlCIEgdcfmWs/6G
         F1cnoKiklzAFyy0aj07xWFdLZwJBbXfOd3JRx2AScL0+AFLHuOpXmHxbLBolzzTcsfrc
         CXy8QI4GtLhgduNTcx/tjD5WNrjBXSVJU0LWU2iXTN3gOcWXNbswQUE9CMHyCRyKRSNY
         AgdoTnu7pzjNPAl18fr5IcOs1eJN63eIbuuLIiWkRTqWDvXIRYXZm1Icyiru6osSINsK
         thz/lR8cMGBt7DbkqKUlNvrCMAOfCRDieB6H6RkNTxeHcl29uHK5O9kvTQQkihlE9Ula
         BRYw==
X-Gm-Message-State: AOAM530VeSkWw9LXWEoIKEjL1/IfKxfoZsDxE0iINSshIx4zIDcGB60y
        VmZm0CSlMi2VKNxG2wWLr8RyeU4Cwd+L9s+ki/40UQIK47++9ki8k1ATE5PwhqMAGioYIv0KHMN
        TSK7UJwTlyNOtN677zeKL2pXnlA==
X-Received: by 2002:a05:620a:4446:: with SMTP id w6mr44672982qkp.273.1641564790441;
        Fri, 07 Jan 2022 06:13:10 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyxpJ4Sg3lAOJt40+fckPzVrfV1SS+laz3cGFmL/vYslY4erIf4p5P2MVtYSxieCu2+92/1+w==
X-Received: by 2002:a05:620a:4446:: with SMTP id w6mr44672964qkp.273.1641564790148;
        Fri, 07 Jan 2022 06:13:10 -0800 (PST)
Received: from [192.168.1.9] (pool-68-163-101-245.bstnma.fios.verizon.net. [68.163.101.245])
        by smtp.gmail.com with ESMTPSA id o17sm3509317qkp.89.2022.01.07.06.13.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Jan 2022 06:13:09 -0800 (PST)
To:     David Vernet <void@manifault.com>, live-patching@vger.kernel.org,
        linux-kernel@vger.kernel.org, jpoimboe@redhat.com,
        pmladek@suse.com, jikos@kernel.org, mbenes@suse.cz
References: <20211229215646.830451-1-void@manifault.com>
From:   Joe Lawrence <joe.lawrence@redhat.com>
Subject: Re: [PATCH] livepatch: Avoid CPU hogging with cond_resched
Message-ID: <1f1b9b01-cfab-8a84-f35f-c21172e5d64d@redhat.com>
Date:   Fri, 7 Jan 2022 09:13:08 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20211229215646.830451-1-void@manifault.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On 12/29/21 4:56 PM, David Vernet wrote:
> For example, under certain workloads, enabling a KLP patch with
> many objects or functions may cause ksoftirqd to be starved, and thus for
> interrupts to be backlogged and delayed.

Just curious, approximately how many objects/functions does it take to
hit this condition?  While the livepatching kselftests are more about
API and kernel correctness, this sounds like an interesting test case
for some of the other (out of tree) test suites.

Thanks,
-- 
Joe

