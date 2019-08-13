Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD9438BA0C
	for <lists+live-patching@lfdr.de>; Tue, 13 Aug 2019 15:24:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728536AbfHMNYh (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 13 Aug 2019 09:24:37 -0400
Received: from mx2.suse.de ([195.135.220.15]:52340 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728134AbfHMNYh (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Tue, 13 Aug 2019 09:24:37 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C6C30AE62;
        Tue, 13 Aug 2019 13:24:35 +0000 (UTC)
Date:   Tue, 13 Aug 2019 15:24:30 +0200 (CEST)
From:   Miroslav Benes <mbenes@suse.cz>
To:     Petr Mladek <pmladek@suse.com>
cc:     Jiri Kosina <jikos@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Nicolai Stange <nstange@suse.de>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/5] livepatch: Keep replaced patches until post_patch
 callback is called
In-Reply-To: <20190719074034.29761-2-pmladek@suse.com>
Message-ID: <alpine.LSU.2.21.1908131523260.10477@pobox.suse.cz>
References: <20190719074034.29761-1-pmladek@suse.com> <20190719074034.29761-2-pmladek@suse.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, 19 Jul 2019, Petr Mladek wrote:

> Pre/post (un)patch callbacks might manipulate the system state. Cumulative
> livepatches might need to take over the changes made by the replaced
> ones. For this they might need to access some data stored or referenced
> by the old livepatches.
> 
> Therefore the replaced livepatches has to stay around until post_patch()

s/has/have/

Miroslav
