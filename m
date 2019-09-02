Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4665CA5B34
	for <lists+live-patching@lfdr.de>; Mon,  2 Sep 2019 18:14:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726023AbfIBQNf (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 2 Sep 2019 12:13:35 -0400
Received: from mx2.suse.de ([195.135.220.15]:36648 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725830AbfIBQNf (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Mon, 2 Sep 2019 12:13:35 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 55740AE3A;
        Mon,  2 Sep 2019 16:13:34 +0000 (UTC)
Date:   Mon, 2 Sep 2019 18:13:21 +0200 (CEST)
From:   Miroslav Benes <mbenes@suse.cz>
To:     Josh Poimboeuf <jpoimboe@redhat.com>
cc:     Petr Mladek <pmladek@suse.com>, jikos@kernel.org,
        joe.lawrence@redhat.com, linux-kernel@vger.kernel.org,
        live-patching@vger.kernel.org
Subject: Re: [RFC PATCH 2/2] livepatch: Clear relocation targets on a module
 removal
In-Reply-To: <20190826145449.wyo7avwpqyriem46@treble>
Message-ID: <alpine.LSU.2.21.1909021802180.29987@pobox.suse.cz>
References: <20190719122840.15353-1-mbenes@suse.cz> <20190719122840.15353-3-mbenes@suse.cz> <20190728200427.dbrojgu7hafphia7@treble> <alpine.LSU.2.21.1908141256150.16696@pobox.suse.cz> <20190814151244.5xoaxib5iya2qjco@treble> <20190816094608.3p2z73oxcoqavnm4@pathway.suse.cz>
 <20190822223649.ptg6e7qyvosrljqx@treble> <20190823081306.kbkm7b4deqrare2v@pathway.suse.cz> <20190826145449.wyo7avwpqyriem46@treble>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

> I can easily foresee more problems like those in the future.  Going
> forward we have to always keep track of which special sections are
> needed for which architectures.  Those special sections can change over
> time, or can simply be overlooked for a given architecture.  It's
> fragile.

Indeed. It bothers me a lot. Even x86 "port" is not feature complete in 
this regard (jump labels, alternatives,...) and who knows what lurks in 
the corners of the other architectures we support.

So it is in itself reason enough to do something about late module 
patching.

Miroslav
