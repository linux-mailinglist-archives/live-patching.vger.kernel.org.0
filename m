Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9B286BF629
	for <lists+live-patching@lfdr.de>; Sat, 18 Mar 2023 00:20:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230104AbjCQXUR (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 17 Mar 2023 19:20:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229798AbjCQXUQ (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 17 Mar 2023 19:20:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E98E23A4C0;
        Fri, 17 Mar 2023 16:20:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8489060C22;
        Fri, 17 Mar 2023 23:20:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90EC4C433D2;
        Fri, 17 Mar 2023 23:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679095212;
        bh=nVPX6NHkNS1ASVWQcSBpKkJlrRG4rVOrNovxnnSnVak=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GJurI3b/SaclGXYQoD3eHpGeVGxbvTNgIST9+hS47GpTq8k5268GvLX6u/iNAXSMH
         eE4Py8QlzNTlwvvb0fDUik7YzsZMdUXK+eA1LLVyLwnVuEdCjiG7KypnDYxwDssBiA
         /giWPcOWHzz9Z4cmYubz9YyYwkzvrLCK3ErktR9ZIfGGIsxDHKWRjvXHpuWfCxJuoh
         tSpOIEgb0RQdjLzgvHdN91an2L21wP/DUOQ0NA2lekIzGJ+8xDT1s5mBSyXR7mzTac
         GiAp0W14m79Zn3amudLs7g6CCebZm0MauNQ+gSVdmqx7KB2uH8UERWRsyJlbjRCsoL
         J9tvRK5IxVt/g==
Date:   Fri, 17 Mar 2023 16:20:10 -0700
From:   Josh Poimboeuf <jpoimboe@kernel.org>
To:     Joe Lawrence <joe.lawrence@redhat.com>
Cc:     Marcos Paulo de Souza <mpdesouza@suse.de>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org, Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Marcos Paulo de Souza <mpdesouza@suse.com>
Subject: Re: [PATCH v7 00/10] livepatch: klp-convert tool
Message-ID: <20230317232010.7uq6tt4ty35eo5hm@treble>
References: <20230306140824.3858543-1-joe.lawrence@redhat.com>
 <20230314202356.kal22jracaw5442y@daedalus>
 <ZBTNvEPrCcRj3F1C@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZBTNvEPrCcRj3F1C@redhat.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, Mar 17, 2023 at 04:29:48PM -0400, Joe Lawrence wrote:
> Have you tried retrofitting klp-convert into any real-world livepatch?
> I'm curious as to your observations on the overall experience, or
> thoughts on the sympos annotation style noted above.

On a related note, the patch creation process (of which klp-convert
would be part of) needs to be documented.

If I remember correctly, the proper safe usage of klp-convert requires a
kernel built with -flive-patching, plus some scripting and/or manual
processes.

If nobody knows how to safely use it then there wouldn't be much value
in merging it.

-- 
Josh
