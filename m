Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0350220CB3
	for <lists+live-patching@lfdr.de>; Wed, 15 Jul 2020 14:12:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730761AbgGOMK4 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 15 Jul 2020 08:10:56 -0400
Received: from [195.135.220.15] ([195.135.220.15]:35144 "EHLO mx2.suse.de"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1726968AbgGOMK4 (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Wed, 15 Jul 2020 08:10:56 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 04DBCB57D;
        Wed, 15 Jul 2020 12:10:58 +0000 (UTC)
Date:   Wed, 15 Jul 2020 14:10:54 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Miroslav Benes <mbenes@suse.cz>
Cc:     Josh Poimboeuf <jpoimboe@redhat.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        live-patching@vger.kernel.org
Subject: Re: linux-next: Tree for Jun 23 (objtool (2))
Message-ID: <20200715121054.GH20226@alley>
References: <20200623162820.3f45feae@canb.auug.org.au>
 <61df2e8f-75e8-d233-9c3c-5b4fa2b7fbdc@infradead.org>
 <20200702123555.bjioosahrs5vjovu@treble>
 <alpine.LSU.2.21.2007141240540.5393@pobox.suse.cz>
 <20200714135747.lcgysd5joguhssas@treble>
 <alpine.LSU.2.21.2007151250390.25290@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.21.2007151250390.25290@pobox.suse.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed 2020-07-15 13:11:14, Miroslav Benes wrote:
> Petr, would you agree to revert -flive-patching.

Yes, I agree.

Best Regards,
Petr
