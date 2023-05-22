Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F16770C56F
	for <lists+live-patching@lfdr.de>; Mon, 22 May 2023 20:42:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229576AbjEVSmo (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 22 May 2023 14:42:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229569AbjEVSmn (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 22 May 2023 14:42:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24EDAC4
        for <live-patching@vger.kernel.org>; Mon, 22 May 2023 11:42:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1684780923;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=B3cak4dq5ZNrQmULyPGjX8GvQOT3hbmpyV3/2svt1tE=;
        b=XAH7ICDIQuSNNn+lSdJAt3c2YBlXqrjk2lq8oQdw8PB/yICFAGbVcLCPPNol7rrDTwv+FW
        TLdAPleA0ZsPikq23Lei/D2K35eeU2cOCeHhqEvkGqkvOPnnLRCrsZXTBi6ZyebVFIQrAm
        CLoZV1XSLZ4DhJI/phkCwNnjql+Pyi0=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-191-_70WDZ1wOYCuCcNBHEt18A-1; Mon, 22 May 2023 14:42:01 -0400
X-MC-Unique: _70WDZ1wOYCuCcNBHEt18A-1
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-62575b17444so12982866d6.2
        for <live-patching@vger.kernel.org>; Mon, 22 May 2023 11:42:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684780921; x=1687372921;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=B3cak4dq5ZNrQmULyPGjX8GvQOT3hbmpyV3/2svt1tE=;
        b=QjttM6NuCv7O0a923CgZ6SD6kV1knyRDKndsekrVv/48mb1VIWw72thFsWacC41O78
         5HHe+cdxunWkrByHA+Cezz9K5yaxe36iV4zAoK6Q7zQjcY/lDlOoD7spmNkuNUiZSwQd
         Jv0j8TrXJdx+3oAcZAppbNkJs7GuXhX2IrRRHci7aY4RNKJu/+B4OcVzlpY3YAyOY80p
         SY6nhlKHwK6BxeuU99MNKeOX+hfsU7CDX0xTTsJ2Hn48S+PI7F8zLfJ8gX1zOw7yJijX
         G97Za4IVJTcGFNLE09Fg0KIAmpHCYSJ97eAd7f+d8ipRLTEG3UJFoEs3ZgH1Ap1oyB5f
         92Sg==
X-Gm-Message-State: AC+VfDxZuljBoau4Afq6PExWYIvaP5RtUgv+Uw53j8ZF/aykC/Sxd/yy
        nzOSXmWMZjCPT9H7FRSvdFHMQTqvZPesKASis0m5rxYem5SIkeSmOB+KEd9NE819/Zq3KDeJo2m
        430ZtSQtsqjmALxc6+/m9dam4Lw==
X-Received: by 2002:a05:6214:224b:b0:623:557d:91c7 with SMTP id c11-20020a056214224b00b00623557d91c7mr23045705qvc.25.1684780920809;
        Mon, 22 May 2023 11:42:00 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6OxVpNs7qRG4D5vuWTsqZTwamdWXGJ4cSufQdGroUsIraKcVDfMGEcX6wi1hHPUfUoWCUX6Q==
X-Received: by 2002:a05:6214:224b:b0:623:557d:91c7 with SMTP id c11-20020a056214224b00b00623557d91c7mr23045687qvc.25.1684780920529;
        Mon, 22 May 2023 11:42:00 -0700 (PDT)
Received: from [192.168.1.30] (pool-68-160-135-240.bstnma.fios.verizon.net. [68.160.135.240])
        by smtp.gmail.com with ESMTPSA id t2-20020a0ce582000000b0062106d10b9bsm2124538qvm.82.2023.05.22.11.41.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 May 2023 11:42:00 -0700 (PDT)
Message-ID: <041b65c7-6016-e03b-106d-1ce793004e34@redhat.com>
Date:   Mon, 22 May 2023 14:41:58 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Content-Language: en-US
To:     Miroslav Benes <mbenes@suse.cz>, jpoimboe@kernel.org,
        jikos@kernel.org, pmladek@suse.com, nstange@suse.de,
        mpdesouza@suse.de, mark.rutland@arm.com, broonie@kernel.org
Cc:     live-patching@vger.kernel.org
References: <alpine.LSU.2.21.2303291339090.21599@pobox.suse.cz>
From:   Joe Lawrence <joe.lawrence@redhat.com>
Subject: Re: Live Patching Microconference at Linux Plumbers
In-Reply-To: <alpine.LSU.2.21.2303291339090.21599@pobox.suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On 3/29/23 08:05, Miroslav Benes wrote:
> Hi,
> 
> we would like to organize Live Patching Microconference at Linux Plumbers 
> 2023. The conference will take place in Richmond, VA, USA. 13-15 November. 
> https://lpc.events/. The call for proposals has been opened so it is time 
> to start the preparation on our side.
> 
> You can find the proposal below. Comments are welcome. The list of topics 
> is open, so feel free to add more. I tried to add key people to discuss 
> the topics, but the list is not exhaustive. I would like to submit the 
> proposal soonish even though the deadline is on 1 June. I assume that we 
> can update the topics later. My plan is to also organize a proper Call for 
> Topics after the submission and advertise it also on LKML.
> 
> Last but not least it would be nice to have a co-runner of the show. Josh, 
> Joe, any volunteer? :)
> 
> Thank you
> Miroslav
> 
> 
> Proposal
> --------
> The Live Patching microconference at Linux Plumbers 2023 aims to gather
> stakeholders and interested parties to discuss proposed features and
> outstanding issues in live patching.
> 
> Live patching is a critical tool for maintaining system uptime and
> security by enabling fixes to be applied to running systems without the
> need for a reboot. The development of the infrastructure is an ongoing
> effort and while many problems have been resolved and features
> implemented, there are still open questions, some with already submitted
> patch sets, which need to be discussed.
> 
> Live Patching microconferences at the previous Linux Plumbers
> conferences proved to be useful in this regard and helped us to find
> final solutions or at least promising directions to push the development
> forward. It includes for example a support for several architectures
> (ppc64le and s390x were added after x86_64), a late module patching and
> module dependencies and user space live patching.
> 
> Currently proposed topics follow. The list is open though and more will
> be added during the regular Call for Topics.
> 
>   - klp-convert (as means to fix CET IBT limitations) and its 
>     upstreamability
>   - shadow variables, global state transition
>   - kselftests and the future direction of development
>   - arm64 live patching
> 
> Key people
> 
>   - Josh Poimboeuf <jpoimboe@kernel.org>
>   - Jiri Kosina <jikos@kernel.org>
>   - Miroslav Benes <mbenes@suse.cz>
>   - Petr Mladek <pmladek@suse.com>
>   - Joe Lawrence <joe.lawrence@redhat.com>
>   - Nicolai Stange <nstange@suse.de>
>   - Marcos Paulo de Souza <mpdesouza@suse.de>
>   - Mark Rutland <mark.rutland@arm.com>
>   - Mark Brown <broonie@kernel.org>
> 
> We encourage all attendees to actively participate in the
> microconference by sharing their ideas, experiences, and insights.
> 

Hi folks,

Gentle bump and call for any late updates to the Live Patching
Microconference Proposal.  I believe we have about a week left to edit
the proposal for consideration at this year's LPC.

See [1] for more info on LPC 2023 and [2] for the currently proposed
microconferences.

[1] https://lpc.events/event/17/
[2[ https://lpc.events/event/17/page/200-proposed-microconferences

-- 
Joe

