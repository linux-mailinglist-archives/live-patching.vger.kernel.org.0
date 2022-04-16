Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19A56503448
	for <lists+live-patching@lfdr.de>; Sat, 16 Apr 2022 07:49:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229766AbiDPCWk (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 15 Apr 2022 22:22:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229872AbiDPCWd (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 15 Apr 2022 22:22:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0929759A5B
        for <live-patching@vger.kernel.org>; Fri, 15 Apr 2022 19:20:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650075602;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WHdkIGOQ4zsXGJMmIQm5BnGhIzeJfdILazCRmHTjv9o=;
        b=Itj6UmryGVlGsZCDpuFP5eolcQGeqHyYiUUM18a7ivRvEukXJkUp0SBnk/5naAKMxfDfdg
        3ZWiQYH77kSK8g6pIYAH+1pUsK1pISesH4uKeeW74/EJyEz9uU8AVqWAwux4vV1jRuZQwH
        xTETAPU/WxXdsx3s5RqFL//QMGRP5Dc=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-609-F-Icz-trOfeZ3Ug_SVb7mg-1; Fri, 15 Apr 2022 21:07:55 -0400
X-MC-Unique: F-Icz-trOfeZ3Ug_SVb7mg-1
Received: by mail-qv1-f69.google.com with SMTP id a3-20020a056214062300b00443cd6175c8so7939773qvx.4
        for <live-patching@vger.kernel.org>; Fri, 15 Apr 2022 18:07:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=WHdkIGOQ4zsXGJMmIQm5BnGhIzeJfdILazCRmHTjv9o=;
        b=ANJbJdSUHWgr1az7kHOmlwo/FU5D+OmavU3x8YzI3tGt+AuWp02qibKIiHnIP0c6FB
         zcRgiGiEeynVctT7Fyx+9o4rhOfa/7FvODkpjYuU/cUGfsq0Yp3b3Rf8/QINtKjKt2+n
         +bpWwrnoUViB+sX8Z//Ad2v+VDNs1JPRNm1p92CdHxWTk4lPFM5UgHXhTsEecqiNWHmd
         bJxSFmYPp1TgfwbIog9NEo0kESzzt4YRqGIqABA8kP/0K/S6G50NMILWAZ/FJpgC1YGl
         Nl1iy8m+BjvZFs2Dm9LqnY8jGuIqMznuLaZuBxpXCi0Ld5G5me6GLK5fdFvzB6RvGGLZ
         Z5Nw==
X-Gm-Message-State: AOAM531pS7Xpc/cupHailKoyafZQN+C2QT9fciTMsN5XGxMowe7ozSsg
        l2Niusf5XgXkiLYZZPFJKygpc5L11FA/f7akWGKxEzn6cqxF+mcQNzOjzRNu3GbzmaIt3CQtluq
        2+3FZb1lSW/u2/Y4woNpvdg9tbg==
X-Received: by 2002:a05:622a:52:b0:2e2:3248:c8 with SMTP id y18-20020a05622a005200b002e2324800c8mr1114952qtw.519.1650071274684;
        Fri, 15 Apr 2022 18:07:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzj92WtHRvw4w/rYZujE+e7lZkDtI6tiDDmPcrT25yaw625DfNGxLnrtxheCc/JrQKWUfZT+w==
X-Received: by 2002:a05:622a:52:b0:2e2:3248:c8 with SMTP id y18-20020a05622a005200b002e2324800c8mr1114931qtw.519.1650071274442;
        Fri, 15 Apr 2022 18:07:54 -0700 (PDT)
Received: from treble ([2600:1700:6e32:6c00::45])
        by smtp.gmail.com with ESMTPSA id k66-20020a37ba45000000b0069c5adb2f2fsm3321870qkf.6.2022.04.15.18.07.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Apr 2022 18:07:53 -0700 (PDT)
Date:   Fri, 15 Apr 2022 18:07:50 -0700
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Cc:     mark.rutland@arm.com, broonie@kernel.org, ardb@kernel.org,
        nobuta.keiya@fujitsu.com, sjitindarsingh@gmail.com,
        catalin.marinas@arm.com, will@kernel.org, jmorris@namei.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v1 0/9] arm64: livepatch: Use DWARF Call Frame
 Information for frame pointer validation
Message-ID: <20220416010750.cuf7tf5dgd434kac@treble>
References: <95691cae4f4504f33d0fc9075541b1e7deefe96f>
 <20220407202518.19780-1-madvenka@linux.microsoft.com>
 <20220408002147.pk7clzruj6sawj7z@treble>
 <15a22f4b-f04a-15e1-8f54-5b3147d8df7d@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <15a22f4b-f04a-15e1-8f54-5b3147d8df7d@linux.microsoft.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon, Apr 11, 2022 at 12:18:13PM -0500, Madhavan T. Venkataraman wrote:
> > There are actually several similarities between your new format and ORC,
> > which is also an objtool-created DWARF alternative.  It would be
> > interesting to see if they could be combined somehow.
> > 
> 
> I will certainly look into it. So, if I decide to merge the two, I might want
> to make a minor change to the ORC structure. Would that be OK with you?

Yes, in fact I would expect it, since ORC is quite x86-specific at the
moment.  So it would need some abstractions to make it more multi-arch
friendly.

-- 
Josh

