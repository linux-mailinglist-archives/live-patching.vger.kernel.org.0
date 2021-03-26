Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95ED634B27A
	for <lists+live-patching@lfdr.de>; Sat, 27 Mar 2021 00:12:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230027AbhCZXL3 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 26 Mar 2021 19:11:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229969AbhCZXK6 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 26 Mar 2021 19:10:58 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7089BC0613AA
        for <live-patching@vger.kernel.org>; Fri, 26 Mar 2021 16:10:58 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id d8so1638388plh.11
        for <live-patching@vger.kernel.org>; Fri, 26 Mar 2021 16:10:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7CxPBGNOJyGJAegkelSBZdLnkdPyLtywVW1PNxMx2sk=;
        b=ZDeLJwzdKyUaDa18s3wXhLOLlLqPUu1hj8zmFihTLadpy0tNlBAUz3/MndNZTcaaom
         zAF3qIBPA2wbWxNHHNcHNqI9ifrOWT29aSutdvsM21GjewN0MCwue4rSSctyka0RYKQC
         Kp9q6CKvTGuSb+FXqM1UQq5oO1eJtfDn5BTVAfeuCiWRjc8Qcfv9xbNQ4pQ7AahDRRWB
         F+Q+nYBceAOmNYrR8rUt9zUQoYpMCZWEHO6nG5iKhMn7zD0sOJ487T9Y4HeZLmub2qn9
         Q6pP9Fyh6LvjN2mqLDuAZxwZDE+nA1PlWu/AvgVB1hpG4U1aaBZxoZbrrVSomblsXZI/
         Y/6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7CxPBGNOJyGJAegkelSBZdLnkdPyLtywVW1PNxMx2sk=;
        b=JeB51FWc78whCRojKxSlIXFx6gIrHVsDNI4Pcp57sghrf/yK2dDqVSuoOhfV+LgTpO
         ceyGPpl1m3ZoCSzIpNjkrpHraErpcsCmwCNCZ0mrrQgd8CHAoCfts5J46YOHiqHtDda2
         09eVTce3CZ+7WVMx14r6yaP5XmtQsTMpHlFf4SFybkvXbh5auvoDKDEzYYcRGQTcBbnB
         jTKB4UtsS/Pwv55X8d2vnQFFmF2Gq/FDQuV84TOJllFZvcAlyC3EJJKQ4mfjIoPxpYKc
         BEwpKNxaXiARqhHW53k8yRN/Xpj/oeqaNfAHeb7jo3VZsN6ztD3NSMiG6OFIm1rh6hbo
         1sWA==
X-Gm-Message-State: AOAM532IF+uKXlfunApN28dz6ya3ZL/p9sYxEXMWPKFwgpsJFr/n+129
        It5pZ5dS5y7WaMrKloRfJdzoJQ==
X-Google-Smtp-Source: ABdhPJyY69ZyA+1gLxCka3LrszGQwXRfBn3BuuflACv0Y3efCrQEYJLk+f64Fdyno/ctYykZkkpdOw==
X-Received: by 2002:a17:90b:201:: with SMTP id fy1mr15467016pjb.108.1616800257847;
        Fri, 26 Mar 2021 16:10:57 -0700 (PDT)
Received: from ?IPv6:2620:10d:c085:21cf::141d? ([2620:10d:c090:400::5:4d27])
        by smtp.gmail.com with ESMTPSA id c193sm10174092pfc.180.2021.03.26.16.10.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Mar 2021 16:10:57 -0700 (PDT)
Subject: Re: [PATCH] livepatch: Replace the fake signal sending with
 TIF_NOTIFY_SIGNAL infrastructure
To:     Miroslav Benes <mbenes@suse.cz>, jpoimboe@redhat.com,
        jikos@kernel.org, pmladek@suse.com, joe.lawrence@redhat.com
Cc:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210326143021.17773-1-mbenes@suse.cz>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <d7fa9065-ed3d-43e0-5940-7c69ffd840af@kernel.dk>
Date:   Fri, 26 Mar 2021 17:10:55 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210326143021.17773-1-mbenes@suse.cz>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On 3/26/21 8:30 AM, Miroslav Benes wrote:
> Livepatch sends a fake signal to all remaining blocking tasks of a
> running transition after a set period of time. It uses TIF_SIGPENDING
> flag for the purpose. Commit 12db8b690010 ("entry: Add support for
> TIF_NOTIFY_SIGNAL") added a generic infrastructure to achieve the same.
> Replace our bespoke solution with the generic one.
> 
> Signed-off-by: Miroslav Benes <mbenes@suse.cz>

Looks good to me.

Reviewed-by: Jens Axboe <axboe@kernel.dk>

-- 
Jens Axboe

