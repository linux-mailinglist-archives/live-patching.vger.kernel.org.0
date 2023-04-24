Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFC496ED57C
	for <lists+live-patching@lfdr.de>; Mon, 24 Apr 2023 21:47:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231975AbjDXTro (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 24 Apr 2023 15:47:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231625AbjDXTrn (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 24 Apr 2023 15:47:43 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBA22527A;
        Mon, 24 Apr 2023 12:47:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=2Do1yeWHcPCiwl4CRls3I2dXsK6tP8pVag3VeASBUgM=; b=RyH62nvw+N9oAHQvClmlrR4pX/
        SpU0VpnH5pHC3JlgThqshqVS9+S7lZpNq5wWmiM1Qsk6GvDKAG3RJXHwdPmJe6XLw4RaibFu7ZR5Y
        7dK/tfunxoAHK6R94go/rtGwAXdDGYFRnnSvf1V0EskrwFBgpSzlsLHIOMCx2/OHksSsNJeCaCdUx
        2KVMF1YuANBj0u+orQWi9ZmZXpmZLuiTO//JIZeNUbU2wHLP27mL1SuZoWK6oyR2e6nIL6XJlt/Ja
        MxxUHQNFIkJiLIdTKEFMCp2zHisoe3ZjegT5FIsyuXypwi1UGca6kvC3s107nlbnBzpQvh1Mo33Dc
        CYzHLEDQ==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1pr29z-00H4WN-1E;
        Mon, 24 Apr 2023 19:47:39 +0000
Date:   Mon, 24 Apr 2023 12:47:39 -0700
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Josh Poimboeuf <jpoimboe@kernel.org>
Cc:     Nick Alcock <nick.alcock@oracle.com>, masahiroy@kernel.org,
        linux-modules@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        linux-kernel@vger.kernel.org, arnd@arndb.de,
        akpm@linux-foundation.org, eugene.loh@oracle.com,
        kris.van.hees@oracle.com, live-patching@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH modules-next v10 00/13] kallsyms: reliable
 symbol->address lookup with /proc/kallmodsyms
Message-ID: <ZEbc20oRFR0f8Qj6@bombadil.infradead.org>
References: <20221205163157.269335-1-nick.alcock@oracle.com>
 <20230407232118.o2x5lakfgyzy56gz@treble>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230407232118.o2x5lakfgyzy56gz@treble>
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

On Fri, Apr 07, 2023 at 04:21:18PM -0700, Josh Poimboeuf wrote:
> Anyway, I was nodding along with the above cover letter until I got to
> the third paragraph.
> 
> A "built-in kernel module" is not actually a module, as it's built in to
> vmlinux.  I suspect the point is that if you rebuild with a different
> config, it might become a module.  But many other changes could also
> occur with a changed config, including changed inlining decisions and
> GCC IPA optimization function renaming, in which case the symbol might
> no longer exist with the new config.

Yes it does not matter, for his tooling effort it was just to be able
to map a possible module to a symbol so tooling can display this to
disambiguate.

> Also I'm confused what it means for a symbol to be "used by multiple
> modules".  If the same TU or inline symbol is linked into two modules,
> it will be loaded twice at two different addresses, and the
> implementations could even differ.

He just wants to be able to map if a symbol with the same name but
different addresses is due to a built-in or a module declaration of
the same symbol so it can use it.

> It sounds like there are two problems being conflated:
> 
>   1) how to uniquely identify symbols in the current kernel
> 
>      For this, all we really need is file+sym.
> 
>      Or, enable -zunique-symbols in the linker.
> 
>   2) how to uniquely identify symbols across multiple kernels/configs
> 
>      This seems much trickier, as much can change across kernels and
>      configs, including compiler inlining and naming decisions, not to
>      mention actual code changes.
> 
> The problems are related, but distinct.
> 
> #2 seems significantly harder to implement properly.
> 
> Would solving #1 give you most of what you need?

I'm not nick but my reading of his goals is that if you peg a
"possible_module" prefix or postfix or whatever, then yes.

For 2) I think it would be good to see if one could just force Kconfig
tristate to add -DPOSSIBLE_MODULE, that would be an easier approach
than the possible-obj-m thing [0] I had suggested last

[0] https://lore.kernel.org/all/Y/kXDqW+7d71C4wz@bombadil.infradead.org/

  Luis
