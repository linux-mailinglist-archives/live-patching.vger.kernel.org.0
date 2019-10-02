Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80ECAC8A19
	for <lists+live-patching@lfdr.de>; Wed,  2 Oct 2019 15:47:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726488AbfJBNqZ (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 2 Oct 2019 09:46:25 -0400
Received: from mx2.suse.de ([195.135.220.15]:56172 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726272AbfJBNqZ (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Wed, 2 Oct 2019 09:46:25 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 08014AD46;
        Wed,  2 Oct 2019 13:46:24 +0000 (UTC)
Date:   Wed, 2 Oct 2019 15:46:23 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Miroslav Benes <mbenes@suse.cz>
Cc:     jikos@kernel.org, jpoimboe@redhat.com, joe.lawrence@redhat.com,
        nstange@suse.de, live-patching@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 3/3] livepatch: Clean up
 klp_update_object_relocations() return paths
Message-ID: <20191002134623.b6mwrvenrywgwdce@pathway.suse.cz>
References: <20190905124514.8944-1-mbenes@suse.cz>
 <20190905124514.8944-4-mbenes@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190905124514.8944-4-mbenes@suse.cz>
User-Agent: NeoMutt/20170912 (1.9.0)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu 2019-09-05 14:45:14, Miroslav Benes wrote:
> Signed-off-by: Miroslav Benes <mbenes@suse.cz>

This might depend on personal preferences. What was the motivation
for this patch, please? Did it just follow some common
style in this source file?

To make it clear. I have no real preference. I just want to avoid
some back and forth changes of the code depending on who touches
it at the moment.

I would prefer to either remove this patch or explain the motivation
in the commit message. Beside that

Reviewed-by: Petr Mladek <pmladek@suse.com>

Best Regards,
Petr
