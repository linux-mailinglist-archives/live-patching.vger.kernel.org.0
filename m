Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 453C828F885
	for <lists+live-patching@lfdr.de>; Thu, 15 Oct 2020 20:28:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727468AbgJOS17 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 15 Oct 2020 14:27:59 -0400
Received: from mx2.suse.de ([195.135.220.15]:39164 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727416AbgJOS16 (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 15 Oct 2020 14:27:58 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 66955AC4C
        for <live-patching@vger.kernel.org>; Thu, 15 Oct 2020 18:27:57 +0000 (UTC)
Date:   Thu, 15 Oct 2020 20:27:57 +0200 (CEST)
From:   Jiri Kosina <jkosina@suse.cz>
To:     live-patching@vger.kernel.org
Subject: livepatching.git#for-linus rebased
Message-ID: <nycvar.YFH.7.76.2010152005130.18859@cbobk.fhfr.pm>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hi,

JFYI I decided to rebase for-linus branch, due to slight confusion, that'd 
result in for-linus be just one commit and one merge commit, which is 
pointless (it's not possible to do ff-merge into for-linus without 
rebasing).

As this is just an integration branch, this should be fine for everybody I 
hope.

Thanks,

-- 
Jiri Kosina
SUSE Labs
