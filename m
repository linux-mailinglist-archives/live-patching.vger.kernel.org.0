Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDFAE629A8B
	for <lists+live-patching@lfdr.de>; Tue, 15 Nov 2022 14:33:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238225AbiKONd2 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 15 Nov 2022 08:33:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238300AbiKONdK (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 15 Nov 2022 08:33:10 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 149CA29808;
        Tue, 15 Nov 2022 05:32:30 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id C7036224F3;
        Tue, 15 Nov 2022 13:32:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1668519148; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oSNaoSAKel5Q3dXgaMtogEqroYGrlcXcisT9sIHHdq8=;
        b=DyQ2C3DTqc2uNz2fOZ8EdKfLVZbPAJFTSPTx3R9PbjbOsZFt97huERNVS7ZAYQv+1v4aX2
        fdIsgxYHuZLrFZj7heAgcVU16pjh7l2lVt4ieWUrEy02sOHEYrabrBE5zBDHqmCrh6s0zM
        kfJJEUQ6EeSkpew5G9TkMpWNTxdNgPQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1668519148;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oSNaoSAKel5Q3dXgaMtogEqroYGrlcXcisT9sIHHdq8=;
        b=mmkBCeK8KnUhJEkcknxdDzcvwCPRfU4yfvkPNHBHwOQoat8Cc9jEAhIaLMcwBpdc9n1eR7
        gvmx4jBKUdyCYVDA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 9453C13273;
        Tue, 15 Nov 2022 13:32:28 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id nX1tI+yUc2OmZQAAMHmgww
        (envelope-from <mliska@suse.cz>); Tue, 15 Nov 2022 13:32:28 +0000
Message-ID: <0a0a3922-dc42-0c42-ecac-b63641ee07d6@suse.cz>
Date:   Tue, 15 Nov 2022 14:32:28 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 40/46] x86/livepatch, lto: Disable live patching with gcc
 LTO
Content-Language: en-US
To:     Josh Poimboeuf <jpoimboe@kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Cc:     "Jiri Slaby (SUSE)" <jirislaby@kernel.org>,
        linux-kernel@vger.kernel.org, Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        live-patching@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Jiri Slaby <jslaby@suse.cz>
References: <20221114114344.18650-1-jirislaby@kernel.org>
 <20221114114344.18650-41-jirislaby@kernel.org>
 <20221114190742.qekt42gvsv2ia3ng@treble>
 <20221114202808.2avu7bscqcyefbpx@two.firstfloor.org>
 <20221114220059.m44nykrau2eata42@treble>
From:   =?UTF-8?Q?Martin_Li=c5=a1ka?= <mliska@suse.cz>
In-Reply-To: <20221114220059.m44nykrau2eata42@treble>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On 11/14/22 23:00, Josh Poimboeuf wrote:
> On Mon, Nov 14, 2022 at 12:28:09PM -0800, Andi Kleen wrote:
>> On Mon, Nov 14, 2022 at 11:07:42AM -0800, Josh Poimboeuf wrote:
>>> On Mon, Nov 14, 2022 at 12:43:38PM +0100, Jiri Slaby (SUSE) wrote:
>>>> From: Andi Kleen <andi@firstfloor.org>
>>>>
>>>> It is not supported by gcc 12 so far, so it causes compiler "sorry"
>>>> messages.
>>>
>>> What specifically is not supported by GCC 12? 
>>
>> -fwhole-program and the live patching options are mutually exclusive.
> 
> What live patching options are you referring to?
> 

As mentioned in the reply to the next email, we speak about:
https://gcc.gnu.org/onlinedocs/gcc/Optimize-Options.html#index-flive-patching
option:

gcc -flto -flive-patching=inline-clone a.c
cc1: sorry, unimplemented: live patching is not supported with LTO

Cheers,
Martin
