Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A5626499EF
	for <lists+live-patching@lfdr.de>; Mon, 12 Dec 2022 09:16:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229681AbiLLIQC (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 12 Dec 2022 03:16:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbiLLIQB (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 12 Dec 2022 03:16:01 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 357E7C745;
        Mon, 12 Dec 2022 00:15:59 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 9C10E337F2;
        Mon, 12 Dec 2022 08:15:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1670832958; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Fkpn+tZcJeudANWrekmNzhJ9sWWRStUcNOk75TUGVOA=;
        b=SJ/+WWdzMjwNVHUSzgOqB/oaFKfchvGfon2Thz64qkaYhD47mzXyBL4U+yxHRN4klzl0+B
        1rUsmxeY/vPKxv9IZtKM/cmn+Yjl4+R9Krt9ssu3+AI9SnyImRzataysig3eXvO2zAJ9Yq
        7ksf3UtdkMkA0dGmk40TEHXOdfTuvkQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1670832958;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Fkpn+tZcJeudANWrekmNzhJ9sWWRStUcNOk75TUGVOA=;
        b=NWtmdhrlM4aNQ/hGXkEvMQzIyNYUxlqdwMKG7pGo9kSYOvG0zhzfbTl9AxBXhMIbsvLxb0
        q3pFWmUqQYmxcPCw==
Received: from pobox.suse.cz (pobox.suse.cz [10.100.2.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 4CD622C141;
        Mon, 12 Dec 2022 08:15:58 +0000 (UTC)
Date:   Mon, 12 Dec 2022 09:16:01 +0100 (CET)
From:   Miroslav Benes <mbenes@suse.cz>
To:     Song Liu <song@kernel.org>
cc:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        jpoimboe@kernel.org, jikos@kernel.org, pmladek@suse.com,
        x86@kernel.org, joe.lawrence@redhat.com,
        linuxppc-dev@lists.ozlabs.org, Josh Poimboeuf <jpoimboe@redhat.com>
Subject: Re: [PATCH v6] livepatch: Clear relocation targets on a module
 removal
In-Reply-To: <CAPhsuW53njtTrL=w33QBY5AiSftNxZ=UOQ1_qZ+qsp5VL1vU0g@mail.gmail.com>
Message-ID: <alpine.LSU.2.21.2212120912270.4964@pobox.suse.cz>
References: <20220901171252.2148348-1-song@kernel.org> <alpine.LSU.2.21.2212091352370.18933@pobox.suse.cz> <CAPhsuW53njtTrL=w33QBY5AiSftNxZ=UOQ1_qZ+qsp5VL1vU0g@mail.gmail.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_SOFTFAIL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

> > Petr has commented on the code aspects. I will just add that s390x was not
> > dealt with at the time because there was no live patching support for
> > s390x back then if I remember correctly and my notes do not lie. The same
> > applies to powerpc32. I think that both should be fixed as well with this
> > patch. It might also help to clean up the ifdeffery in the patch a bit.
> 
> I don't have test environments for s390 and powerpc, so I really don't know
> whether I am doing something sane for them.

I would say that if you implement it, there are people here who would be 
able help with the testing and reviewing the changes if CCed.

> Would you have time to finish these parts? (Or maybe the whole patch..)

Unfortunately I cannot promise anything at the moment. I am really sorry 
about that.

Miroslav
