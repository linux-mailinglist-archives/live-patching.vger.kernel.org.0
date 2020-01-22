Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E1F8145246
	for <lists+live-patching@lfdr.de>; Wed, 22 Jan 2020 11:15:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729061AbgAVKPW (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 22 Jan 2020 05:15:22 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:37309 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728609AbgAVKPT (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 22 Jan 2020 05:15:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579688117;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HuN8xwBV9YhqHIBUUs/6FS3OY1fEoZoqFPlPS7k1hAM=;
        b=Lkno0Ha1XUTiqm50VLeG+Eat19DA61WcITscXH6RHpK7McR11GoOlRFhTQTFeGiD3xjlqC
        xlrTKaavo8QMOp5iyH6xDUsLp7t40zGiL8K3NDhM/+8kUh8DfZSdnf7qtXKivtgYeRn9fv
        q//LazP5Bth5SVJKBZPLG6/C9x4D6ZI=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-182-IQmE4_0sOFWJQbg0-G7cLw-1; Wed, 22 Jan 2020 05:15:15 -0500
X-MC-Unique: IQmE4_0sOFWJQbg0-G7cLw-1
Received: by mail-wr1-f72.google.com with SMTP id o6so2808155wrp.8
        for <live-patching@vger.kernel.org>; Wed, 22 Jan 2020 02:15:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HuN8xwBV9YhqHIBUUs/6FS3OY1fEoZoqFPlPS7k1hAM=;
        b=OK+irlVsP7Exwd8YfAPryg/vSml5+WGyV9K3eTm2pxBbRATdbLxEFMbcnmtU/ohLsx
         40qD8BdfXG7qf7r0WWoBjep5WMZs1Z/x5t9RAv9j4eEt0WD3OjS3Pr7mEqojJxGlqiJl
         1xsZLNdG02NZ/ShKWqvTpmdpyJTkbcOf8+p06opJAFdKwM25rPFuUyLioEyEss80LCFv
         p8rRLhnZJViINYI46GlbFBA2VPVj3vwRQECCBdiay9XNwTS6aHrO8u53E2f6LSSA8KAj
         GL2i6i/xg5VvRmg13hY2Ayu6NDp06KZQHqTonHxkXX8wVEoVraoJQ/FVnEMLJoIUYhAw
         LBdQ==
X-Gm-Message-State: APjAAAVkmZ0jxvB5p5B8Hy0xn7v0DZ2j2LDB8ahjeTrql2dtPHMaj7W9
        yjpuP2H10vfAHZQedCgmfDlESN7UPAyJXx/JpzdLnHM+XbvhwEVZzNopRJUmy3xU5IH/0gkoqbZ
        3fqjmtZvT5A8/EdRDekt1rqk01A==
X-Received: by 2002:a1c:4144:: with SMTP id o65mr2093333wma.81.1579688114094;
        Wed, 22 Jan 2020 02:15:14 -0800 (PST)
X-Google-Smtp-Source: APXvYqy4aJRil/tx8VppIJLye7IN3S0YAWx4OvHVzJ7tulPLojRCiJc2Ih8d67ITRZEjrA1rix0gpA==
X-Received: by 2002:a1c:4144:: with SMTP id o65mr2093323wma.81.1579688113923;
        Wed, 22 Jan 2020 02:15:13 -0800 (PST)
Received: from [192.168.1.81] (host81-140-166-164.range81-140.btcentralplus.com. [81.140.166.164])
        by smtp.gmail.com with ESMTPSA id t1sm3484231wma.43.2020.01.22.02.15.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Jan 2020 02:15:13 -0800 (PST)
Subject: Re: [POC 11/23] livepatch: Safely detect forced transition when
 removing split livepatch modules
To:     Petr Mladek <pmladek@suse.com>, Jiri Kosina <jikos@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>
Cc:     Joe Lawrence <joe.lawrence@redhat.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Nicolai Stange <nstange@suse.de>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200117150323.21801-1-pmladek@suse.com>
 <20200117150323.21801-12-pmladek@suse.com>
From:   Julien Thierry <jthierry@redhat.com>
Message-ID: <2d92bc17-0844-54dd-b6ea-8d89ce2d590b@redhat.com>
Date:   Wed, 22 Jan 2020 10:15:11 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20200117150323.21801-12-pmladek@suse.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hi Petr,

On 1/17/20 3:03 PM, Petr Mladek wrote:
> The information about forced livepatch transition is currently stored
> in struct klp_patch. But there is not any obvious safe way how to
> access it when the split livepatch modules are removed.
> 

If that's the only motivation to do this, klp_objects could have a 
reference to the klp_patch they are part of. This could easily be set 
when adding the klp_object to the klp_patch->obj_list in 
klp_init_object_early() .

Having this reference could also prove useful in future scenarios.

Cheers,

-- 
Julien Thierry

