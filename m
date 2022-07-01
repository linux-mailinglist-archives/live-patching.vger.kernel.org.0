Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7437D5638DF
	for <lists+live-patching@lfdr.de>; Fri,  1 Jul 2022 20:08:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231350AbiGASCf (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 1 Jul 2022 14:02:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbiGASCe (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 1 Jul 2022 14:02:34 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6074F3FBDB;
        Fri,  1 Jul 2022 11:02:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ZPeAoAQGd/dAHDv+0muzdJmtfTPd5PlsJuI6fl18td4=; b=g88+VmrETYRxPZAQwilIOXhYrO
        tNJR6pqKwjPdMW0jx2gfcYlAjA2hl9OKLoENxyPHhtNys//9urQsANz3YjmXFP3ISPntSfJMRGMBy
        cGd8mLUJJFJCEgN5K0E++ig1zW/9uSgQfX3WsVghPJXb4e6owpQdsj4yZVAagjZS42+FX01HIaODk
        WuTZ5E4CCS0MNDUXqhBO0DuJFizELQFpt6UG6bqW7FM2z987RytPn7Vk0kXpgtWJbQSgUw+Zhq4Mj
        25wKqI2B86oNFzhRS8M6in/XzV5Oib31HWyV2g4SOVbxHcCg1AjUCMrKh8Tp6LdWDlnsHCgnjzNhk
        QrOhsIUQ==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o7KyN-006JRZ-CH; Fri, 01 Jul 2022 18:02:31 +0000
Date:   Fri, 1 Jul 2022 11:02:31 -0700
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Helge Deller <deller@gmx.de>
Cc:     jeyu@kernel.org, linux-modules@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org,
        live-patching@vger.kernel.org
Subject: Re: [PATCH 1/2] modules: Ensure natural alignment for
 .altinstructions and __bug_table sections
Message-ID: <Yr82t0PQoYIcx++J@bombadil.infradead.org>
References: <20220627190551.517561-1-deller@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220627190551.517561-1-deller@gmx.de>
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

On Mon, Jun 27, 2022 at 09:05:50PM +0200, Helge Deller wrote:
> In the kernel image vmlinux.lds.S linker scripts the .altinstructions
> and __bug_table sections are 32- or 64-bit aligned because they hold 32-
> and/or 64-bit values.
> 
> But for modules the module.lds.S linker script doesn't define a default
> alignment yet, so the linker chooses the default byte-alignment, which
> then leads to unnecessary unaligned memory accesses at runtime.
> 
> This patch adds the missing alignments.
> 
> Signed-off-by: Helge Deller <deller@gmx.de>

Good catch but does this fix a real world issue? When are
altinstructions used for modules? When are alternatives used
for modules?

How did you notice this issue?

This information should go into the commit log.

  Luis
> ---
>  scripts/module.lds.S | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/scripts/module.lds.S b/scripts/module.lds.S
> index 1d0e1e4dc3d2..3a3aa2354ed8 100644
> --- a/scripts/module.lds.S
> +++ b/scripts/module.lds.S
> @@ -27,6 +27,8 @@ SECTIONS {
>  	.ctors			0 : ALIGN(8) { *(SORT(.ctors.*)) *(.ctors) }
>  	.init_array		0 : ALIGN(8) { *(SORT(.init_array.*)) *(.init_array) }
> 
> +	.altinstructions	0 : ALIGN(8) { KEEP(*(.altinstructions)) }
> +	__bug_table		0 : ALIGN(8) { KEEP(*(__bug_table)) }
>  	__jump_table		0 : ALIGN(8) { KEEP(*(__jump_table)) }
> 
>  	__patchable_function_entries : { *(__patchable_function_entries) }
> --
> 2.35.3
> 
