Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 065A0628BB7
	for <lists+live-patching@lfdr.de>; Mon, 14 Nov 2022 23:01:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235813AbiKNWBF (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 14 Nov 2022 17:01:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235639AbiKNWBE (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 14 Nov 2022 17:01:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA0A4CE11;
        Mon, 14 Nov 2022 14:01:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 58A4961481;
        Mon, 14 Nov 2022 22:01:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 574F4C433D6;
        Mon, 14 Nov 2022 22:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668463261;
        bh=o/aLYyyKyYJE7zm70gVgea3UiHn5hD+KHBApvEQ508k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=B732TN/nLzSMa0PO7sOrfGW0oCyAxg6htArDdIByPHN5WJ5SRahRO3DZzVcetdlV5
         yvqcwRaZQI/ovtOzF7lWcziO6coKWEjUN9RZzJTx4Z/IvkjJk0FMoKjs6VmjLAXL/Q
         gVPI1OsYpfxYmSeaqhIx2Qmee7QrjhdssCR0KF6L1C93wzhy8z+fi1rMYWaWJ1OWgn
         y3mFBTfXyFsTtCmrPdtaIeqKupku6FjR/2rj71laTyxO90e9Ua1kfLGb3KSRcS6L4O
         2cOa5mPHZQsLL+v/Nd2ZmgzKpIISkdPMr8+IKqbGm3eQw0/DKdyFvt3TrYGV6hA4FW
         rDDs/Lr2+cfNg==
Date:   Mon, 14 Nov 2022 14:00:59 -0800
From:   Josh Poimboeuf <jpoimboe@kernel.org>
To:     Andi Kleen <andi@firstfloor.org>
Cc:     "Jiri Slaby (SUSE)" <jirislaby@kernel.org>,
        linux-kernel@vger.kernel.org, Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        live-patching@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Martin Liska <mliska@suse.cz>, Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH 40/46] x86/livepatch, lto: Disable live patching with gcc
 LTO
Message-ID: <20221114220059.m44nykrau2eata42@treble>
References: <20221114114344.18650-1-jirislaby@kernel.org>
 <20221114114344.18650-41-jirislaby@kernel.org>
 <20221114190742.qekt42gvsv2ia3ng@treble>
 <20221114202808.2avu7bscqcyefbpx@two.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221114202808.2avu7bscqcyefbpx@two.firstfloor.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon, Nov 14, 2022 at 12:28:09PM -0800, Andi Kleen wrote:
> On Mon, Nov 14, 2022 at 11:07:42AM -0800, Josh Poimboeuf wrote:
> > On Mon, Nov 14, 2022 at 12:43:38PM +0100, Jiri Slaby (SUSE) wrote:
> > > From: Andi Kleen <andi@firstfloor.org>
> > > 
> > > It is not supported by gcc 12 so far, so it causes compiler "sorry"
> > > messages.
> > 
> > What specifically is not supported by GCC 12? 
> 
> -fwhole-program and the live patching options are mutually exclusive.

What live patching options are you referring to?

-- 
Josh
