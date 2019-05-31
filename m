Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59E5431576
	for <lists+live-patching@lfdr.de>; Fri, 31 May 2019 21:39:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727122AbfEaTjR (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 31 May 2019 15:39:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33840 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726808AbfEaTjQ (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 31 May 2019 15:39:16 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 530FF3082201;
        Fri, 31 May 2019 19:39:14 +0000 (UTC)
Received: from treble (ovpn-124-142.rdu2.redhat.com [10.10.124.142])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E257C5D9D1;
        Fri, 31 May 2019 19:39:09 +0000 (UTC)
Date:   Fri, 31 May 2019 14:39:08 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Petr Mladek <pmladek@suse.com>
Cc:     Jiri Kosina <jikos@kernel.org>, Miroslav Benes <mbenes@suse.cz>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] livepatch: Use static buffer for debugging messages
 under rq lock
Message-ID: <20190531193908.nltikmafed36iozh@treble>
References: <20190531074147.27616-1-pmladek@suse.com>
 <20190531074147.27616-4-pmladek@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190531074147.27616-4-pmladek@suse.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Fri, 31 May 2019 19:39:16 +0000 (UTC)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, May 31, 2019 at 09:41:47AM +0200, Petr Mladek wrote:
> The err_buf array uses 128 bytes of stack space.  Move it off the stack
> by making it static.  It's safe to use a shared buffer because
> klp_try_switch_task() is called under klp_mutex.
> 
> Signed-off-by: Petr Mladek <pmladek@suse.com>
> Acked-by: Miroslav Benes <mbenes@suse.cz>
> Reviewed-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>

Acked-by: Josh Poimboeuf <jpoimboe@redhat.com>

-- 
Josh
