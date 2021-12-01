Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 787024655F2
	for <lists+live-patching@lfdr.de>; Wed,  1 Dec 2021 19:57:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241584AbhLATA0 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 1 Dec 2021 14:00:26 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:54148 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232079AbhLATAZ (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 1 Dec 2021 14:00:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638385024;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TMx7/TO/N/tgq+bovqUBJ3OM9EENsWtQuCOo2Ncxf4I=;
        b=cXPaYC9tbsJRW//uJSdH+vofUKr+riDkW7dJ3hLfNtAQeuMLAnEZBXNzocR3oKf2rZ9FVG
        gjdb/NUpI6+cC9PQJgW25tu3y0+artFMyHfU3LQbpgAKIBKN522t3VBdGg2i++QBJg/F8i
        5WX660FH7NTeUCJxuDSqjkFEfF8/6nI=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-585-4c8eYcgvPGO8s2tQAYpnGQ-1; Wed, 01 Dec 2021 13:57:03 -0500
X-MC-Unique: 4c8eYcgvPGO8s2tQAYpnGQ-1
Received: by mail-qt1-f198.google.com with SMTP id y25-20020ac87059000000b002a71d24c242so33575464qtm.0
        for <live-patching@vger.kernel.org>; Wed, 01 Dec 2021 10:57:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TMx7/TO/N/tgq+bovqUBJ3OM9EENsWtQuCOo2Ncxf4I=;
        b=PLYDiUzfzovGRNEnLmwYoNmzX3tricK6+r9HxkNQ6UfGr3Q+X2TvsrWMvZsQwwDZB9
         rVqH8rhrtJZPEijDRktKuH2AF/bjIdcriwC41wgWaY8klWkosKJiGA4frnt3+4qye6T4
         WITme4YRipPwpUOA3OC4lBbDRHF058Ah6lbKt6JWSQ+JEZM2G/uWWtZAV7DHvWalrvdJ
         ICSOB+WQLNviI3RQ/kVptoLqcq5J8MllNQAprUj7fBEVsKqbBhAgwX56a6MKKNzVQqlM
         OlXG9k6VsajlmYJKWXvSSv2FTABRryJ84pck5ex/wjIADWkUX1nGndk1LYJ2uICO3DtN
         Hx+A==
X-Gm-Message-State: AOAM533bVeRRKGtuD/2UJAvXF34Ps5VURVzqrLx//I8WzY8iQVtK6bNr
        P4y/4rLJC8f6n5i6ePfA2E4ZvNEAXgjMgAH0sLFhv7fMnjmD4ciKzV9xjQBDx2xLqpmV7TZUsQC
        P48iAUo5ObvwnCcnB3gZBnAPnkcE+EmHoSMGiAQSLKyO2+24d1iDKtQm/mC/OyZiL5weiXRKTPH
        z6joDa8ok=
X-Received: by 2002:a05:6214:b94:: with SMTP id fe20mr8201100qvb.109.1638385022756;
        Wed, 01 Dec 2021 10:57:02 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwXQeMA9PeNGY7XoY101Qpfwk8t0uE7vKjzUvd0wEGK+fNeaRhLgrItBp/YkWqkIjKyG+SALA==
X-Received: by 2002:a05:6214:b94:: with SMTP id fe20mr8201071qvb.109.1638385022499;
        Wed, 01 Dec 2021 10:57:02 -0800 (PST)
Received: from [192.168.1.9] (pool-68-163-101-245.bstnma.fios.verizon.net. [68.163.101.245])
        by smtp.gmail.com with ESMTPSA id r20sm344533qkp.21.2021.12.01.10.57.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Dec 2021 10:57:01 -0800 (PST)
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Miroslav Benes <mbenes@suse.cz>, joao@overdrivepizza.com,
        nstange@suse.de, pmladek@suse.cz, jpoimboe@redhat.com,
        live-patching@vger.kernel.org
References: <70828ca9f840960c7a3f66cd8dc141f5@overdrivepizza.com>
 <alpine.LSU.2.21.2111231035460.15177@pobox.suse.cz>
 <08d4a24d-02c2-6760-96bf-b72f51025808@redhat.com>
 <20211123211636.GE721624@worktop.programming.kicks-ass.net>
From:   Joe Lawrence <joe.lawrence@redhat.com>
Subject: Re: CET/IBT support and live-patches
Message-ID: <ec0205e5-c974-35d4-651a-f622f44fb84e@redhat.com>
Date:   Wed, 1 Dec 2021 13:57:00 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20211123211636.GE721624@worktop.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On 11/23/21 4:16 PM, Peter Zijlstra wrote:
> On Tue, Nov 23, 2021 at 03:58:51PM -0500, Joe Lawrence wrote:
> 
>> Yep, kpatch-build uses its own klp-relocation conversion and not kallsyms.
>>
>> I'm not familiar with CET/IBT, but it sounds like if a function pointer
>> is not taken at build time (or maybe some other annotation), the
>> compiler won't generate the needed endbr landing spot in said function?
> 
> Currently it does, but then I'm having objtool scribble it on purpose.
> 

Hi Peter -- to follow up on the objtool part: what criteria is used to
determine that it may scribble out the endbr?

Thanks,
-- 
Joe

