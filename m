Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46BFF563C11
	for <lists+live-patching@lfdr.de>; Fri,  1 Jul 2022 23:49:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230388AbiGAVth (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 1 Jul 2022 17:49:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbiGAVtf (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 1 Jul 2022 17:49:35 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A40F5925B;
        Fri,  1 Jul 2022 14:49:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=fjeXK1KZbGprcvCBSDuxzycjeEJ3g+xJ7Sip51yEnQ8=; b=K3K5sLpPzzqguJkgowRr6+XHZE
        zBcK98guCTsDg3wPwvINIEnbEeQtjm+2kx4yLPYv/eZi4oNGX2V6HzO90ge8K9k+EYDdlSR6nsgFY
        uy3fewggenXepq689csZ95Ezwl0eoyYwQP0FnWNHNLril64eErscnKUX7Ut3nWsLpbpFheHes/+Ch
        5hQuz5kVaErWQ11vQRPS+MF28uPlq9YlrzAkxMqeTtsYZEyUctWTCw1cbiCY8VzT29tUU1u8QLHoS
        /uLTYUM+R5wXgt87nWZ1ASDkqjobPkaPN5h1BSBnk91/z73O0PASHu1OcwXJXREETewdBJhhVWLk3
        vlriCCIg==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o7OW6-00760i-Sx; Fri, 01 Jul 2022 21:49:34 +0000
Date:   Fri, 1 Jul 2022 14:49:34 -0700
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Masahiro Yamada <masahiroy@kernel.org>
Cc:     linux-modules@vger.kernel.org,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        live-patching@vger.kernel.org, Alex Shi <alexs@kernel.org>,
        Federico Vaga <federico.vaga@vaga.pv.it>,
        Jonathan Corbet <corbet@lwn.net>,
        Matthias Maennich <maennich@google.com>,
        Yanteng Si <siyanteng@loongson.cn>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] doc: module: update file references
Message-ID: <Yr9r7nVASTv3cVky@bombadil.infradead.org>
References: <20220613081741.1699713-1-masahiroy@kernel.org>
 <Yr9ryl7SiiAlMQ0f@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yr9ryl7SiiAlMQ0f@bombadil.infradead.org>
Sender: Luis Chamberlain <mcgrof@infradead.org>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, Jul 01, 2022 at 02:48:58PM -0700, Luis Chamberlain wrote:
> On Mon, Jun 13, 2022 at 05:17:40PM +0900, Masahiro Yamada wrote:
> > Adjust documents to the file moves made by commit cfc1d277891e ("module:
> > Move all into module/").
> > 
> > Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
> 
> Queued up, thanks!

Sorry, missed the v2, taking that.

  Luis
