Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8742FF5AD
	for <lists+live-patching@lfdr.de>; Tue, 30 Apr 2019 13:32:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726436AbfD3Lcp (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 30 Apr 2019 07:32:45 -0400
Received: from mx2.suse.de ([195.135.220.15]:41544 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726202AbfD3Lcp (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Tue, 30 Apr 2019 07:32:45 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 63784AF95;
        Tue, 30 Apr 2019 11:32:44 +0000 (UTC)
Date:   Tue, 30 Apr 2019 13:32:43 +0200 (CEST)
From:   Miroslav Benes <mbenes@suse.cz>
To:     Petr Mladek <pmladek@suse.com>
cc:     Jiri Kosina <jikos@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] livepatch: Use static buffer for debugging messages
 under rq lock
In-Reply-To: <20190430091049.30413-3-pmladek@suse.com>
Message-ID: <alpine.LSU.2.21.1904301332310.8507@pobox.suse.cz>
References: <20190430091049.30413-1-pmladek@suse.com> <20190430091049.30413-3-pmladek@suse.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, 30 Apr 2019, Petr Mladek wrote:

> klp_try_switch_task() is called under klp_mutex. The buffer for
> debugging messages might be static.
> 
> Signed-off-by: Petr Mladek <pmladek@suse.com>

Acked-by: Miroslav Benes <mbenes@suse.cz>

Miroslav
