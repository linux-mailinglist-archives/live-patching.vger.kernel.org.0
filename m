Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E0286CEF59
	for <lists+live-patching@lfdr.de>; Wed, 29 Mar 2023 18:29:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229695AbjC2Q3C (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 29 Mar 2023 12:29:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229687AbjC2Q3B (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 29 Mar 2023 12:29:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51AF8126
        for <live-patching@vger.kernel.org>; Wed, 29 Mar 2023 09:28:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680107295;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xWkDus+pypkiVfiTbAz41QkVGzbGZjNdSpOWx1pXHgQ=;
        b=BoVzShesqcFDq5ebVo6wTySVotSXFcJqAssL6qGc2D+WCbHFiqdrClKPMlIVydubnS6dv0
        FYwAb/asLH6B3yPoS38XBiJ6AtyOIf0QpilPyNUBXbM0mO0NKrBl54CpVNCTEuOeBzgEUG
        F/rUJs6kLEejeSZJYHm6XByyXr8D17A=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-468-rnlQH1pWP_eJp5xEgLGNcQ-1; Wed, 29 Mar 2023 12:28:14 -0400
X-MC-Unique: rnlQH1pWP_eJp5xEgLGNcQ-1
Received: by mail-qk1-f199.google.com with SMTP id q143-20020a374395000000b0074690a17414so7610609qka.7
        for <live-patching@vger.kernel.org>; Wed, 29 Mar 2023 09:28:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680107293;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xWkDus+pypkiVfiTbAz41QkVGzbGZjNdSpOWx1pXHgQ=;
        b=2hEleLFijrvtinlfQCZvdmiHezNr/6A/f6b5uNPYlnBCal9S4QmB2l6tLbIQBIDBUY
         SOZgwk4H0TnJZ5KLz7Fqzxn4jS7cpgoYOmPmju+GgakuPoIlDZMNHZTXvZ7Af0hiPul+
         fSUoXvz1ab9fukQz4a9ShTEVl5N6OtP1WvSPEKHWGHF4YJljA2bCwEw/NHcuCAtzAsYh
         r4+ymgKFDHF1U9U4R2b7ke5pikzcL5lhebZ1Hhtlvp4NdCfMr/ZKT39qTlSkEKqN5LjT
         bAXiZ0O0msuB37z7ZugNTwppPkvOcRZC9Sxjxu/hiil8yZ1YTco/ppdr4eIevwtQ/Vfk
         k7ag==
X-Gm-Message-State: AAQBX9euVHN++HscE72wbDKr+ZOCIQY0By0E7Gm0CpLp+uDR85m1eOc+
        FRhmwl3ri1dTl4QHMe2g6QjjMk7T+da1NjoaEAUdjrYCbSyvhlnVf1W+hbY1+FVyFyy5BhD03tE
        PgWMi6Q3/xMl0ae128DVTW2BUFGDtR6b02A==
X-Received: by 2002:a05:622a:188:b0:3e4:eb8f:8a7b with SMTP id s8-20020a05622a018800b003e4eb8f8a7bmr4007453qtw.29.1680107293656;
        Wed, 29 Mar 2023 09:28:13 -0700 (PDT)
X-Google-Smtp-Source: AKy350ZltJLuDFn8ui/rD204FdSAWgU3g+E9TI/Y3LobCPa/y1wV5WmD8nKXoAkGMWlWRHDSscPUhA==
X-Received: by 2002:a05:622a:188:b0:3e4:eb8f:8a7b with SMTP id s8-20020a05622a018800b003e4eb8f8a7bmr4007432qtw.29.1680107293386;
        Wed, 29 Mar 2023 09:28:13 -0700 (PDT)
Received: from [192.168.1.9] (pool-68-160-135-240.bstnma.fios.verizon.net. [68.160.135.240])
        by smtp.gmail.com with ESMTPSA id z2-20020ac86b82000000b003e38e0d3e84sm6831764qts.72.2023.03.29.09.28.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Mar 2023 09:28:13 -0700 (PDT)
Message-ID: <d90054d4-72d9-3725-8c75-bfe8554c7a0e@redhat.com>
Date:   Wed, 29 Mar 2023 12:28:11 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: Live Patching Microconference at Linux Plumbers
Content-Language: en-US
To:     Miroslav Benes <mbenes@suse.cz>, jpoimboe@kernel.org,
        jikos@kernel.org, pmladek@suse.com, nstange@suse.de,
        mpdesouza@suse.de, mark.rutland@arm.com, broonie@kernel.org
Cc:     live-patching@vger.kernel.org
References: <alpine.LSU.2.21.2303291339090.21599@pobox.suse.cz>
From:   Joe Lawrence <joe.lawrence@redhat.com>
In-Reply-To: <alpine.LSU.2.21.2303291339090.21599@pobox.suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On 3/29/23 08:05, Miroslav Benes wrote:
> Last but not least it would be nice to have a co-runner of the show. Josh, 
> Joe, any volunteer? 😄

Sure, lmk whatever help you need to co-run.

-- 
Joe

