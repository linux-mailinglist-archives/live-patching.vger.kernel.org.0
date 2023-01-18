Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9945D672B13
	for <lists+live-patching@lfdr.de>; Wed, 18 Jan 2023 23:08:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229746AbjARWIS (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 18 Jan 2023 17:08:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229757AbjARWIS (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 18 Jan 2023 17:08:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41A886309E;
        Wed, 18 Jan 2023 14:08:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D4E28B81D7E;
        Wed, 18 Jan 2023 22:08:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AF35C433EF;
        Wed, 18 Jan 2023 22:08:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674079694;
        bh=2xtau7plmXqGiqi6aOh4Poqgd4EbYmZSUXvErstuhvk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=osttHVIh4eACk+rKzgqwdDdIDgMpHUk4eMeG3yG3kp27De8BgcMptoqCFBh11IiHZ
         GtWqhyEb8NrSLVLEdIWMqPjsGUJrmKFYPFDr67SG/Ful+OyygYUQMUzmko36DXzwew
         /I0FppBqACcJfJqrZ6eS0KQkM5GhRxlVA6sGDZtLd/QpxH1Xs+hM0vjk7fGS3gfGdb
         JsZvBMijBcrwLbP1UhyOE40HzQSCcopdTI0M1iRaUIS9nScXXI12OMPIgCHsvWhO1v
         i7LsPgkErbGKD6vpp0f1xG9K6eof5BTqofgn7hm486UHjlDU6jtK6tRGQQoEHbnLpO
         /gfqj2i2TwywQ==
Date:   Wed, 18 Jan 2023 14:08:12 -0800
From:   Josh Poimboeuf <jpoimboe@kernel.org>
To:     Song Liu <song@kernel.org>
Cc:     linux-kernel@vger.kernel.org, linux-modules@vger.kernel.org,
        live-patching@vger.kernel.org, x86@kernel.org, jikos@kernel.org,
        pmladek@suse.com, joe.lawrence@redhat.com,
        Miroslav Benes <mbenes@suse.cz>,
        Josh Poimboeuf <jpoimboe@redhat.com>
Subject: Re: [PATCH v9] livepatch: Clear relocation targets on a module
 removal
Message-ID: <20230118220812.dvztwhlmliypefha@treble>
References: <20230118204728.1876249-1-song@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230118204728.1876249-1-song@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, Jan 18, 2023 at 12:47:28PM -0800, Song Liu wrote:
> From: Miroslav Benes <mbenes@suse.cz>
> 
> Josh reported a bug:
> 
>   When the object to be patched is a module, and that module is
>   rmmod'ed and reloaded, it fails to load with:
> 
>   module: x86/modules: Skipping invalid relocation target, existing value is nonzero for type 2, loc 00000000ba0302e9, val ffffffffa03e293c
>   livepatch: failed to initialize patch 'livepatch_nfsd' for module 'nfsd' (-8)
>   livepatch: patch 'livepatch_nfsd' failed for module 'nfsd', refusing to load module 'nfsd'
> 
>   The livepatch module has a relocation which references a symbol
>   in the _previous_ loading of nfsd. When apply_relocate_add()
>   tries to replace the old relocation with a new one, it sees that
>   the previous one is nonzero and it errors out.
> 
>   On ppc64le, we have a similar issue:
> 
>   module_64: livepatch_nfsd: Expected nop after call, got e8410018 at e_show+0x60/0x548 [livepatch_nfsd]
>   livepatch: failed to initialize patch 'livepatch_nfsd' for module 'nfsd' (-8)
>   livepatch: patch 'livepatch_nfsd' failed for module 'nfsd', refusing to load module 'nfsd'

Shouldn't there also be a fix for this powerpc issue?

-- 
Josh
