Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3964D441BED
	for <lists+live-patching@lfdr.de>; Mon,  1 Nov 2021 14:48:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231366AbhKANvM (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 1 Nov 2021 09:51:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:30516 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231981AbhKANvM (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 1 Nov 2021 09:51:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635774518;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fUvxJ6sHDgJdM4f4VUnretPE62bc9g1QjZAGZwCNrvA=;
        b=Zru+uhdgc/0iG1XcR4ixhq/z1AxoliwJO4QF0ImjIqJ0wTZ1llQ8shcJ0cP97FpNZEDrKO
        0KL66Fahmnu8lC+awUR6qeStnddxTOxaYjVlQr+pRf/IUkGiZMN4uub9k3Mi7CxaiMk5Ns
        hP++aU27UPN/IDNiR/qB83AON65A4NQ=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-104-pPXih_N5MqWYgSgex1yyyw-1; Mon, 01 Nov 2021 09:48:37 -0400
X-MC-Unique: pPXih_N5MqWYgSgex1yyyw-1
Received: by mail-qv1-f71.google.com with SMTP id o3-20020a0562140e4300b0039a8ccca8efso9018850qvc.7
        for <live-patching@vger.kernel.org>; Mon, 01 Nov 2021 06:48:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fUvxJ6sHDgJdM4f4VUnretPE62bc9g1QjZAGZwCNrvA=;
        b=XDCyjGjTLsL75btSgf/cRrqvgjn/s0MoZ9bwh+uGDswPSZEiBb3TNOMQ7hXRLfQLzU
         5mgw4NYKy8Y7lRVcrmp8UZe5dodVZEOuDXsz53RkOGT1Y9LSrYXfX/FU6md1ByFH6VGs
         Rpt2Nt//O157nHjVXb4EiiuYPzxNn4Q1GWMCZB88BdY6yvI0sepg67CVaUL5yMY8sv/M
         xPzMEythbK7YgzMKQy5VJ+vwokhZRVYj+xjoiJCdVbOwd3KjhMIMSMw4iyyc7RRXfjcg
         VJUnNfxbeInskmA2hf1W2xJLe9f+1qrIQCvtQaVacnr55bjxq+3T1wzBFCHKrKD2IFpS
         XdbQ==
X-Gm-Message-State: AOAM5324GviEIlroP5mdFScQXLTvGQHfJMNlRjxoRXks1kbnMEwMLy/i
        U1MgedSFpdQosdIWqEBg3KaAwXX168WNFyNsbJx1ai5xTio4Lge6oLSWo7PJKsNBDi3+NGAjf1O
        0JGPMtWJPFXtCHeZX4NPA6QxEtQ==
X-Received: by 2002:a05:622a:104a:: with SMTP id f10mr14545415qte.152.1635774517021;
        Mon, 01 Nov 2021 06:48:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyfUmyxsnDKK0JrXAQRngNQ9XzatuIuwKj9TJR+5paLb5+bXTrgMTuIngwjKknwuhu1LGx+PA==
X-Received: by 2002:a05:622a:104a:: with SMTP id f10mr14545389qte.152.1635774516819;
        Mon, 01 Nov 2021 06:48:36 -0700 (PDT)
Received: from [192.168.1.9] (pool-68-163-101-245.bstnma.fios.verizon.net. [68.163.101.245])
        by smtp.gmail.com with ESMTPSA id f66sm5529271qkj.76.2021.11.01.06.48.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Nov 2021 06:48:36 -0700 (PDT)
Subject: Re: ppc64le STRICT_MODULE_RWX and livepatch apply_relocate_add()
 crashes
To:     Russell Currey <ruscur@russell.cc>, live-patching@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Cc:     Josh Poimboeuf <jpoimboe@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Jessica Yu <jeyu@kernel.org>,
        Jordan Niethe <jniethe5@gmail.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>
References: <YX9UUBeudSUuJs01@redhat.com>
 <7ee0c84650617e6307b29674dd0a12c7258417cf.camel@russell.cc>
From:   Joe Lawrence <joe.lawrence@redhat.com>
Message-ID: <f8a96ac1-fda3-92da-cf27-0992a43a2f3f@redhat.com>
Date:   Mon, 1 Nov 2021 09:48:35 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <7ee0c84650617e6307b29674dd0a12c7258417cf.camel@russell.cc>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On 11/1/21 5:20 AM, Russell Currey wrote:
> I'm looking into this now, will update when there's progress.  I
> personally wasn't aware but Jordan flagged this as an issue back in
> August [0].  Are the selftests in the klp-convert tree sufficient for
> testing?  I'm not especially familiar with livepatching & haven't used
> the userspace tools.
> 

Hi Russell, thanks for taking a look.

Testing with that klp-convert tree is probably the quickest and easiest
way to verify the late relocations.

I'm happy to setup and test additional tools (ie, kpatch-build) with any
potential changes as I know they take longer to config and run.

Thanks,

-- 
Joe

