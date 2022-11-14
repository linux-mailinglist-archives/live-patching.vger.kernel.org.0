Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1DD5628AB6
	for <lists+live-patching@lfdr.de>; Mon, 14 Nov 2022 21:46:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237628AbiKNUqe (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 14 Nov 2022 15:46:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237062AbiKNUqe (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 14 Nov 2022 15:46:34 -0500
X-Greylist: delayed 600 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 14 Nov 2022 12:46:33 PST
Received: from one.firstfloor.org (one.firstfloor.org [193.170.194.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C34121A7
        for <live-patching@vger.kernel.org>; Mon, 14 Nov 2022 12:46:33 -0800 (PST)
Received: by one.firstfloor.org (Postfix, from userid 503)
        id DE8FE86FF9; Mon, 14 Nov 2022 21:28:09 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=firstfloor.org;
        s=mail; t=1668457689;
        bh=fgAS67UCZGIk0fAA2aL4IJohGVeHheYpz6QU8F8/cfQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pJdUJpuaGnX7VvEaARJoCnG9qiIkkBQ7HVsEoan/oYyorwZLKCYGhMiAnRYxRStXF
         HU+ZZrzrizGjlNjOZMRyvDtNf/ZtTytTCE62USF+ITlGOQX8I3N30cGNK1Iqx7d2li
         zeBzHnGDGBd3erqEj7dqBI78KrTjwh/ekV4FgAaI=
Date:   Mon, 14 Nov 2022 12:28:09 -0800
From:   Andi Kleen <andi@firstfloor.org>
To:     Josh Poimboeuf <jpoimboe@kernel.org>
Cc:     "Jiri Slaby (SUSE)" <jirislaby@kernel.org>,
        linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        live-patching@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Martin Liska <mliska@suse.cz>, Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH 40/46] x86/livepatch, lto: Disable live patching with gcc
 LTO
Message-ID: <20221114202808.2avu7bscqcyefbpx@two.firstfloor.org>
References: <20221114114344.18650-1-jirislaby@kernel.org>
 <20221114114344.18650-41-jirislaby@kernel.org>
 <20221114190742.qekt42gvsv2ia3ng@treble>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221114190742.qekt42gvsv2ia3ng@treble>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon, Nov 14, 2022 at 11:07:42AM -0800, Josh Poimboeuf wrote:
> On Mon, Nov 14, 2022 at 12:43:38PM +0100, Jiri Slaby (SUSE) wrote:
> > From: Andi Kleen <andi@firstfloor.org>
> > 
> > It is not supported by gcc 12 so far, so it causes compiler "sorry"
> > messages.
> 
> What specifically is not supported by GCC 12? 

-fwhole-program and the live patching options are mutually exclusive.
Okay I suppose it could be handled by disabling -fwhole-program, although 
that might limit some optimizations.

> What are the "sorry" messages?

It's an error message from the compiler telling you that something is
not implemented.


-Andi
