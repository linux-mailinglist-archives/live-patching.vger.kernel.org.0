Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D062184829
	for <lists+live-patching@lfdr.de>; Fri, 13 Mar 2020 14:30:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726591AbgCMNay (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 13 Mar 2020 09:30:54 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:41894 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726554AbgCMNay (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 13 Mar 2020 09:30:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584106253;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Zr+KPeie+yoAZtVSZnlWsX5gt6YKL/Jm3XuRBVo7aJw=;
        b=KtJ2gIu++0XxDEta6W3g/cN179ISFU5H5r3r6+Dhv6XtrV8aRELr57bBIZPpz295s8/k5V
        tXlpf0Ia/qoIHOQsibkLQQuGn3hUUegFHenVM9szmVciZXnbffHTYML8LaYF9C7l/Xo2MC
        +uBUJIQ4+nGm6Ke0VZypCyFClQrZ8ZU=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-338-auGgvM1_Pv2jjNtuJ9vyvg-1; Fri, 13 Mar 2020 09:30:47 -0400
X-MC-Unique: auGgvM1_Pv2jjNtuJ9vyvg-1
Received: by mail-wr1-f69.google.com with SMTP id q18so4260142wrw.5
        for <live-patching@vger.kernel.org>; Fri, 13 Mar 2020 06:30:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Zr+KPeie+yoAZtVSZnlWsX5gt6YKL/Jm3XuRBVo7aJw=;
        b=dS+hRuTZHY6vQn+gSfg9dTOw3mNhIHtp59EAumh6gH0jqhqEuLLnrJB59FIUV32Awb
         ODrz927+ckpRCQXL5UDxgy+kA8m9hzZqOJHfmtDKHATz/V8hoO3nysf8JKJ95/nNCNVg
         2Ijp78pyJW29zp4DnxK2Z2WC8iSuIYctbNXvlHo0CwLTpPIAKEeKNMUuyuDScbQBR1B7
         I4E+2Kk3+t6/DyUCSZ3zxo78TJle+i/znogrZDyxiRiv2wJTTsuyjVbF57fiLcYIkNA+
         y2RdGTC+DrOYoaK871akqbezyfR+HpsJyKbKe1fJL5ylLkcGKqCOdOvEBTeZKardcf7x
         hjnw==
X-Gm-Message-State: ANhLgQ0beOyXUa9SXvpFydAS356oQzdxu9tYBVdWkWzDIG0JXvVDP3xE
        yoCL0EGPanK1/BGwiTTndjUyi/xPMWnHSvpi/BN3EKKlIbTa7Buv1CJHidpcUl3XplYVuhggHG7
        kuqICDZjjmPKaRoQzNtbrUapb3A==
X-Received: by 2002:adf:a2d9:: with SMTP id t25mr17639097wra.414.1584106245999;
        Fri, 13 Mar 2020 06:30:45 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vsLYemjmrrWZxRzt/EOX2o+jDs1q9FV/8Dx1PNh1Lwu84a2s5vkEYAn4ev4AeQJvdwy8uViKw==
X-Received: by 2002:adf:a2d9:: with SMTP id t25mr17639079wra.414.1584106245699;
        Fri, 13 Mar 2020 06:30:45 -0700 (PDT)
Received: from ?IPv6:2a01:cb14:58d:8400:ecf6:58e2:9c06:a308? ([2a01:cb14:58d:8400:ecf6:58e2:9c06:a308])
        by smtp.gmail.com with ESMTPSA id c72sm16626306wme.35.2020.03.13.06.30.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Mar 2020 06:30:45 -0700 (PDT)
Subject: Re: Current status about arm64 livepatch support
To:     Mark Rutland <mark.rutland@arm.com>,
        Xiao Yang <yangx.jy@cn.fujitsu.com>
Cc:     Torsten Duwe <duwe@suse.de>, Torsten Duwe <duwe@lst.de>,
        linux-arm-kernel@lists.infradead.org,
        Mark Brown <broonie@kernel.org>, live-patching@vger.kernel.org
References: <5E5F5647.3040705@cn.fujitsu.com>
 <5E6AEF8B.4090905@cn.fujitsu.com>
 <20200313122244.GI42546@lakrids.cambridge.arm.com>
From:   Julien Thierry <jthierry@redhat.com>
Message-ID: <f248adc0-e3c5-0519-3a4e-50935d0d1a76@redhat.com>
Date:   Fri, 13 Mar 2020 13:30:44 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200313122244.GI42546@lakrids.cambridge.arm.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

[Cc-ing live-patching mailing list which might also be interested in the 
progress of arm64 support]

On 3/13/20 12:22 PM, Mark Rutland wrote:
> On Fri, Mar 13, 2020 at 10:27:23AM +0800, Xiao Yang wrote:
>> Hi,
>>
>> Ping.
>>
>> Best Regards,
>> Xiao Yang
>>
>> On 2020/3/4 15:18, Xiao Yang wrote:
>>> Hi Torsten,
>>>
>>> Sorry to bother you.
>>>
>>> I focus on arm64 livepatch support recently and saw that you have tried
>>> to implement it by:
>>> -------------------------------------------------------------------------------
>>> http://lists.infradead.org/pipermail/linux-arm-kernel/2018-October/609126.html
>>> http://lists.infradead.org/pipermail/linux-arm-kernel/2018-October/609124.html
>>> http://lists.infradead.org/pipermail/linux-arm-kernel/2018-October/609125.html
>>> -------------------------------------------------------------------------------
>>>
>>> This patch set seems to be blocked because of some issues, but your
>>> another patch set inlcuding the first one "arm64: implement ftrace with
>>> regs" has been merged into upstream kernel:
>>> -------------------------------------------------------------------------------
>>> http://lists.infradead.org/pipermail/linux-arm-kernel/2019-February/631104.html
>>> http://lists.infradead.org/pipermail/linux-arm-kernel/2019-February/631107.html
>>> http://lists.infradead.org/pipermail/linux-arm-kernel/2019-February/631105.html
>>> http://lists.infradead.org/pipermail/linux-arm-kernel/2019-February/631106.html
>>> http://lists.infradead.org/pipermail/linux-arm-kernel/2019-February/631114.html
>>> --------------------------------------------------------------------------------
>>>
>>> Could you tell me current status about arm64 livepatch support?
>>> For example:
>>> 1) Are you(or someone) still working on arm64 livepatch support?
>>> 2) Are there some unresolved problems about arm64 livepatch support?
>>>      What are they?
>>> 3) Will you send a newer version for arm64 livepatch support recently?
> 
> 1) I beleive a few people are working on portions of this.
> 
> 2) I believe that some work is necessary.
> 
>     Julien Thierry has done some work on objtool, which is necessary to
>     check ensure that sequences (including assembly functions) manipulate
>     the stack, and calls/returns as we expect. Mark Brown has been
>     converting our assembly to use modern annotations which objtool
>     consumes when checking this.
> 

I've recently started working on the arm64 objtool again and saw the 
work to use new annotations by Mark B. which is very helpful, thanks for 
that. I've rebased the objtool work on them and working on solving the 
new/remaining objtool warnings.

I've also reworked the arm64 decoder. I'm not sure yet when I'll be able 
to post a new version but it's coming!

>     There might be additional assembly work necessary for this, depending
>     on any deecisions we make for objtool.
> 
>     For reliable stack tracing we may need to rework some assemvly and/or
>     rework the stack tracing code. That will likely depend on the objtool
>     bits.
> 

There is one thing I'll be introducing in the next arm64 objtool 
patchset which are unwind_hints (inspired from 
arch/x86/include/asm/unhind_hints.h) which are annotation indicating in 
which state we expect the stack to be when entering assembly code or 
fiddling with stack registers in the middle of assembly code.

I haven't finished the work on that yet.

Cheers,

-- 
Julien Thierry

