Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DCE04C06C6
	for <lists+live-patching@lfdr.de>; Wed, 23 Feb 2022 02:16:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232404AbiBWBQy (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 22 Feb 2022 20:16:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231136AbiBWBQy (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 22 Feb 2022 20:16:54 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1B1539B8E;
        Tue, 22 Feb 2022 17:16:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description;
        bh=VZfI083wOuo8B8Z3o/ODodReqRbao/97YGDobejD3PE=; b=fERsDHE2587eIln0cElC4w1/DQ
        4BxBvgnOa/uvD1nS3/oVM5eIk/cOIr8/re5U7MwibUHG2JpdApNubnVfHBZXsYd9082DEsxHpuOnF
        9qMCkqGXMJG+RTez9Berq/utaoQFP2Z8nrC4gZkXa/qj7BldSvMpEq9Mg4z1Vm1C6yXPSbMw40yfk
        tVrU4cM4qIMHfaMgtCm5BnPxCegCi4HdwkiHY+rSJZxLGlS/DivycLJKnT/77MqgW5Jwcmlo+D7K4
        lkBHzmq/1nQn/0HUBRdQGlSTKZ9yazuAEYBuD+JXgcbRmaXrZTLnSQFqx/hhwxlcu2fA6WNTGCCpD
        Qxm3cEww==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nMgGR-00C5ie-Ed; Wed, 23 Feb 2022 01:16:19 +0000
Date:   Tue, 22 Feb 2022 17:16:19 -0800
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Aaron Tomlin <atomlin@redhat.com>,
        Thiago Jung Bauermann <bauerman@linux.ibm.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Philipp Rudo <prudo@linux.ibm.com>
Cc:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        "cl@linux.com" <cl@linux.com>,
        "pmladek@suse.com" <pmladek@suse.com>,
        "mbenes@suse.cz" <mbenes@suse.cz>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "jeyu@kernel.org" <jeyu@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-modules@vger.kernel.org" <linux-modules@vger.kernel.org>,
        "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>,
        "atomlin@atomlin.com" <atomlin@atomlin.com>,
        "ghalat@redhat.com" <ghalat@redhat.com>,
        "allen.lkml@gmail.com" <allen.lkml@gmail.com>,
        "joe@perches.com" <joe@perches.com>,
        "msuchanek@suse.de" <msuchanek@suse.de>,
        "oleksandr@natalenko.name" <oleksandr@natalenko.name>
Subject: Re: [PATCH v6 01/13] module: Move all into module/
Message-ID: <YhWK4woM1g2fAq72@bombadil.infradead.org>
References: <20220218212511.887059-1-atomlin@redhat.com>
 <20220218212511.887059-2-atomlin@redhat.com>
 <69fcaad3-e48c-11ca-ed50-7a18831e3e91@csgroup.eu>
 <CANfR36js06qG8HkQBPPz8bnYzcBRUtiZJAqhynt4XJcfcFXAQg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANfR36js06qG8HkQBPPz8bnYzcBRUtiZJAqhynt4XJcfcFXAQg@mail.gmail.com>
Sender: Luis Chamberlain <mcgrof@infradead.org>
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, Feb 22, 2022 at 10:48:00AM +0000, Aaron Tomlin wrote:
> On Mon 2022-02-21 12:21 +0000, Christophe Leroy wrote:
> > Le 18/02/2022 à 22:24, Aaron Tomlin a écrit :
> > >   kernel/{module_signature.c => module/signature.c}   | 0
> > Keeping it outside of kernel/module/ would allow to conditionaly build
> > entire kernel/module/ based of CONFIG_MODULES and then avoid all checks
> > against CONFIG_MODULES which look misleading at times.
> 
> Luis,
> 
> What is your opinion on this? Indeed, mod_check_sig() is used by code
> outside of kernel/module/ too i.e. ima_read_modsig(); albeit, I believe it
> does make sense to keep it under kernel/module/ since the function in
> question is used to review a given module's signature anyway.

How about:

obj-$(CONFIG_MODULE_SIG_FORMAT) += module/module_signature.o 

  Luis
